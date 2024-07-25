# frozen_string_literal: true

module Net
  module NATPMP
    # General exception
    class Exception < ::RuntimeError; end

    class InvalidParameter < Exception; end
  end
end
