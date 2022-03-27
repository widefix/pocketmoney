class ApplicationAction
  extend Dry::Initializer

  def perform
    perform_implementation
  end

  private

  def perform_implementation
    raise NotImplementedError
  end
end
