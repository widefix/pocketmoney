RSpec::Matchers.define :send_email do |options = {}|
  match do |actual|
    @before_count = ActionMailer::Base.deliveries.count
    actual.call
    @after_count = ActionMailer::Base.deliveries.count

    emails_sent = @after_count > @before_count

    if options[:to]
      # Check if emails were sent to specific recipients
      recent_emails = ActionMailer::Base.deliveries.last(@after_count - @before_count)
      expected_recipients = Array(options[:to])

      # Check if all expected recipients received emails
      all_recipients = recent_emails.flat_map(&:to)
      expected_recipients.all? { |recipient| all_recipients.include?(recipient) }
    else
      emails_sent
    end
  end

  match_when_negated do |actual|
    @before_count = ActionMailer::Base.deliveries.count
    actual.call
    @after_count = ActionMailer::Base.deliveries.count

    if options[:to]
      # Check that no emails were sent to specific recipients
      recent_emails = ActionMailer::Base.deliveries.last(@after_count - @before_count)
      expected_recipients = Array(options[:to])

      all_recipients = recent_emails.flat_map(&:to)
      expected_recipients.none? { |recipient| all_recipients.include?(recipient) }
    else
      @after_count == @before_count
    end
  end

  failure_message do |actual|
    if options[:to]
      "expected #{actual} to send email to #{options[:to]}, but it didn't"
    else
      "expected #{actual} to send email, but it didn't"
    end
  end

  failure_message_when_negated do |actual|
    if options[:to]
      "expected #{actual} not to send email to #{options[:to]}, but it did"
    else
      "expected #{actual} not to send email, but it did"
    end
  end

  supports_block_expectations
end
