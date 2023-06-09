# frozen_string_literal: true

module CaskCop
  shared_examples "does not report any offenses" do
    it "does not report any offenses" do
      expect_no_offenses(source)
    end
  end

  shared_examples "reports offenses" do
    it "reports offenses" do
      expect_reported_offenses(source, expected_offenses)
    end
  end

  shared_examples "autocorrects source" do
    it "autocorrects source" do
      expect_autocorrected_source(source, correct_source)
    end
  end

  def expect_no_offenses(source)
    expect(inspect_source(source)).to be_empty
  end

  def expect_reported_offenses(source, expected_offenses)
    offenses = inspect_source(source)
    expect(offenses.size).to eq(expected_offenses.size)
    expected_offenses.zip(offenses).each do |expected, actual|
      expect_offense2(expected, actual)
    end
  end

  def expect_offense2(expected, actual)
    expect(actual.message).to eq(expected[:message])
    expect(actual.severity).to eq(expected[:severity])
    expect(actual.line).to eq(expected[:line])
    expect(actual.column).to eq(expected[:column])
    expect(actual.location.source).to eq(expected[:source])
  end

  # TODO: Replace with `expect_correction` from `rubocop-rspec`.
  def expect_autocorrected_source(source, correct_source)
    correct_source = Array(correct_source).join("\n")

    current_source = source

    # RuboCop runs auto-correction in a loop to handle nested offenses.
    loop do
      current_source = autocorrect_source(current_source)

      if (ignored_nodes = cop.instance_variable_get(:@ignored_nodes)) && ignored_nodes.any?
        ignored_nodes.clear
        next
      end

      break
    end

    expect(current_source).to eq correct_source
  end
end
