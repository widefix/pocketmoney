# frozen_string_literal: true

# Puma currently runs a single process. Keep counters separate from Rails.cache,
# which can be a NullStore. Use a shared Redis/Memcached store before scaling to
# multiple processes or servers; MemoryStore limits apply to each process.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new(size: 16.megabytes)

# Match path segments, not user-agent names: scanner identities can be spoofed.
# Decode escaped paths so /%2eenv is treated the same as /.env.
Rack::Attack.blocklist('secret-file probes') do |request|
  path = Rack::Utils.unescape_path(request.path).downcase
  path.match?(%r{/(?:\.env(?:[._-][^/]*)?|\.git|\.ssh|private[-_]key(?:\.[^/]*)?|id_(?:rsa|ed25519)(?:\.pub)?)(?:/|\z)})
end

# Health checks must remain available even when an IP has hit its limit.
# Static files are served earlier in the middleware stack and are not counted.
Rack::Attack.throttle('dynamic requests/ip', limit: 300, period: 60) do |request|
  next if %w[GET HEAD].include?(request.request_method) && request.path == '/health'

  ActionDispatch::Request.new(request.env).remote_ip
end

Rack::Attack.blocklisted_responder = lambda do |_request|
  [403, { 'Content-Type' => 'text/plain', 'Cache-Control' => 'no-store' }, ["Forbidden\n"]]
end

Rack::Attack.throttled_responder = lambda do |request|
  period = request.env.fetch('rack.attack.match_data').fetch(:period)
  retry_after = period - (Time.now.to_i % period)
  [429, { 'Content-Type' => 'text/plain', 'Cache-Control' => 'no-store',
          'Retry-After' => retry_after.to_s }, ["Too many requests\n"]]
end
