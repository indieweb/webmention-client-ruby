FROM mcr.microsoft.com/devcontainers/ruby:2.7-bullseye

# Configure editors and pagers
ENV EDITOR="nano" \
    VISUAL="code --wait" \
    PAGER="less" \
    LESS="-FMR"

# Silence Ruby deprecation warnings
ENV RUBYOPT="-W:no-deprecated"

# Configure ruby/debug gem
ENV RUBY_DEBUG_HISTORY_FILE="/workspace/.rdbg_history" \
    RUBY_DEBUG_SAVE_HISTORY="1000"

# Configure RubyGems to skip gem documentation
RUN echo "gem: --no-document" >> ~/.gemrc

WORKDIR /workspace
