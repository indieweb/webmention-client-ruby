# frozen_string_literal: true

require "irb/completion"

IRB.conf[:HISTORY_FILE] = ".irb_history"
IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:USE_PAGER] = false
