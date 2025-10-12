# Use Ruby 3.1.7 as base image
FROM ruby:3.1.7-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs \
      npm \
      git \
      curl \
      libvips \
      && rm -rf /var/lib/apt/lists/* \
      && npm install -g yarn

# Set working directory
WORKDIR /rails

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Configure bundler and install gems
ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

RUN bundle install

# Copy package.json and yarn.lock if they exist
COPY package*.json yarn.lock* ./

# Install JavaScript dependencies
RUN if [ -f "package.json" ]; then yarn install; fi

# Copy application code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Create a non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails:rails

# Expose port
EXPOSE 3000

# Configure healthcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
