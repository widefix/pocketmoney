# frozen_string_literal: true

# Exercise the real middleware without booting Rails or requiring a database.
require 'spec_helper'
require 'active_support/all'
require 'rails'
require 'action_dispatch'
require 'rack/attack'
require 'active_support/testing/time_helpers'

require_relative '../../config/initializers/rack_attack'

RSpec.describe Rack::Attack do
  include ActiveSupport::Testing::TimeHelpers

  let(:downstream) { ->(_env) { [200, { 'Content-Type' => 'text/plain' }, ['OK']] } }
  let(:app) { ActionDispatch::RemoteIp.new(described_class.new(downstream)) }
  let(:client) { Rack::MockRequest.new(app) }

  around do |example|
    travel_to(Time.utc(2026, 10, 28, 12, 0, 0)) do
      described_class.cache.store.clear
      example.run
    ensure
      described_class.cache.store.clear
    end
  end

  def get(path, ip: '198.51.100.10', **headers)
    client.get(path, { 'REMOTE_ADDR' => ip }.merge(headers))
  end

  it 'blocks secret probes, including encoded paths and AI bot user agents' do
    paths = %w[/private-key /.env.live /.env.stage /.env_sample /var/.env /static/.env
               /panel/.env /tmp/.env /store/.env /private/.env /common/.env /pipeline/.env
               /%2eenv /%2Egit/config /.ssh/id_rsa /id_ed25519 /.ENV]
    paths.each do |path|
      response = get(path, 'HTTP_USER_AGENT' => 'PerplexityBot/1.0')
      expect(response.status).to eq(403), path
    end
  end

  it 'does not pass blocked requests to downstream exception reporting or routing' do
    expect(downstream).not_to receive(:call)
    expect(get('/.env').status).to eq(403)
  end

  it 'allows legitimate paths and does not block based on bot names alone' do
    %w[/ /users/sign_in /accounts /policy /.well-known/acme-challenge/token /environment].each do |path|
      expect(get(path, 'HTTP_USER_AGENT' => 'PerplexityBot/1.0').status).to eq(200)
    end
  end

  it 'limits each client separately and allows requests again in the next window' do
    300.times { expect(get('/accounts').status).to eq(200) }
    response = get('/accounts')
    expect(response.status).to eq(429)
    expect(response['Retry-After']).to eq('60')
    expect(get('/accounts', ip: '198.51.100.11').status).to eq(200)
    travel 60.seconds
    expect(get('/accounts').status).to eq(200)
  end

  it 'uses the client IP behind the deployment proxy rather than grouping all clients together' do
    300.times do
      get('/accounts', ip: '172.18.0.2', 'HTTP_X_FORWARDED_FOR' => '198.51.100.10')
    end
    expect(get('/accounts', ip: '172.18.0.2', 'HTTP_X_FORWARDED_FOR' => '198.51.100.10').status).to eq(429)
    expect(get('/accounts', ip: '172.18.0.2', 'HTTP_X_FORWARDED_FOR' => '198.51.100.11').status).to eq(200)
  end

  it 'does not let a client evade throttling by prepending a spoofed forwarded IP' do
    300.times { get('/accounts') }
    expect(get('/accounts', 'HTTP_X_FORWARDED_FOR' => '203.0.113.99, 198.51.100.10').status).to eq(429)
  end

  it 'keeps health checks available without consuming the request allowance' do
    301.times { expect(get('/health').status).to eq(200) }
    300.times { get('/accounts') }
    expect(get('/accounts').status).to eq(429)
    expect(get('/health').status).to eq(200)
    expect(client.head('/health', 'REMOTE_ADDR' => '198.51.100.10').status).to eq(200)
  end
end
