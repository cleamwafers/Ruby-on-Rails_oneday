# frozen_string_literal: true

require "formula"
require "software_spec"

describe Bottle::Filename do
  subject { described_class.new(name, version, tag, rebuild) }

  let(:name) { "user/repo/foo" }
  let(:version) { "1.0" }
  let(:tag) { :tag }
  let(:rebuild) { 0 }

  describe "#extname" do
    its(:extname) { is_expected.to eq ".tag.bottle.tar.gz" }

    context "when rebuild is 0" do
      its(:extname) { is_expected.to eq ".tag.bottle.tar.gz" }
    end

    context "when rebuild is 1" do
      let(:rebuild) { 1 }

      its(:extname) { is_expected.to eq ".tag.bottle.1.tar.gz" }
    end
  end

  describe "#to_s and #to_str" do
    its(:to_s) { is_expected.to eq "foo--1.0.tag.bottle.tar.gz" }
    its(:to_str) { is_expected.to eq "foo--1.0.tag.bottle.tar.gz" }
  end

  describe "#url_encode" do
    its(:url_encode) { is_expected.to eq "foo-1.0.tag.bottle.tar.gz" }
  end

  describe "#github_packages" do
    its(:github_packages) { is_expected.to eq "foo--1.0.tag.bottle.tar.gz" }
  end

  describe "#json" do
    its(:json) { is_expected.to eq "foo--1.0.tag.bottle.json" }

    context "when rebuild is 1" do
      its(:json) { is_expected.to eq "foo--1.0.tag.bottle.json" }
    end
  end

  describe "::create" do
    subject { described_class.create(f, :tag, 0) }

    let(:f) do
      formula do
        url "https://brew.sh/foo.tar.gz"
        version "1.0"
      end
    end

    its(:to_s) { is_expected.to eq "formula_name--1.0.tag.bottle.tar.gz" }
  end
end
