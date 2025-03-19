class ComplyTime
  class << self
    @@table = {}
    @@logger = nil

    def method_missing(method_symbol, *args, &block)
      block_parameter = ", #{block.inspect}" if block_given?
      Vagrant.global_logger.debug "
      method_missing:
        #{caller[0]}:#{method_symbol}(#{args.inspect}#{block_parameter})
      "

      if !args[0].nil?
        @@table[method_symbol] = args[0]
      end
      if !@@table.key?(method_symbol)
        raise "
No value for #{method_symbol} has been set in the file vagrant-vars.rb.
If you think it has been set double check the spelling and remember not to use an =
This is wrong:    #{method_symbol} = \"value\"
This is correct:  #{method_symbol} \"value\""
      end
      @@table[method_symbol]
    end

    def load()
      file_path = '../vagrant-vars.rb'
      self.class_eval(File.read(file_path), file_path, 1)
    end
  end
end

ComplyTime.load