require 'rails_helper'

RSpec.describe WeatherPresenter do
  let!(:weather_presenter) { described_class.new({}) }

  describe "#nice_weather" do
    subject { weather_presenter.nice_weather? }

    context "when description is 'Sunny'" do
      before do
        allow(weather_presenter).to receive(:description).and_return('Sunny')
      end

      specify { expect(subject).to be(true) }
    end

    context "when description is 'Partly cloudy'" do
      before do
        allow(weather_presenter).to receive(:description).and_return('Partly cloudy')
      end

      specify { expect(subject).to be(true) }
    end

    context "when description is 'Rainy'" do
      before do
        allow(weather_presenter).to receive(:description).and_return('Rainy')
      end

      specify { expect(subject).to be(false) }
    end

  end

  describe "#good_to_read_outside?" do
    subject { weather_presenter.good_to_read_outside? }

    context "when it is nice weather and temperature is higher than 15" do
      before do
        allow(weather_presenter).to receive(:nice_weather?).and_return(true)
        allow(weather_presenter).to receive(:temperature).and_return(20)
      end

      specify { expect(subject).to be(true) }
    end

    context "when it is nice weather and temperature is lower than 15" do
      before do
        allow(weather_presenter).to receive(:nice_weather?).and_return(true)
        allow(weather_presenter).to receive(:temperature).and_return(12)
      end

      specify { expect(subject).to be(false) }
    end

    context "when it is bad weather and temperature is lower than 15" do
      before do
        allow(weather_presenter).to receive(:nice_weather?).and_return(false)
        allow(weather_presenter).to receive(:temperature).and_return(10)
      end

      specify { expect(subject).to be(false) }
    end

    context "when it is bad weather and temperature is higher than 15" do
      before do
        allow(weather_presenter).to receive(:nice_weather?).and_return(false)
        allow(weather_presenter).to receive(:temperature).and_return(18)
      end

      specify { expect(subject).to be(false) }
    end
  end

  describe "#encourage_text" do
    subject { weather_presenter.encourage_text }

    context "when it is good to read outside" do
      before do
        allow(weather_presenter).to receive(:good_to_read_outside?).and_return(true)
      end

      specify { expect(subject).to eql("Get some snacks and go read a book in a park!") }
    end

    context "when it is not good weather to read outside" do
      before do
        allow(weather_presenter).to receive(:good_to_read_outside?).and_return(false)
      end

      specify { expect(subject).to eql("It's always a good weather to read a book!") }
    end
  end

  describe "#description" do
    let(:description_text) { 'Sunny' }
    let(:data) { { current: { condition: { text: description_text } } } }

    specify { expect(described_class.new(JSON.parse(data.to_json)).description).to eql(description_text) }
  end

  describe "#temperature" do
    let(:data) { { current: { temp_c: 18 } } }

    specify { expect(described_class.new(JSON.parse(data.to_json)).temperature).to eql(18) }
  end

  describe "#icon" do
    let(:icon_url) { Faker::LoremFlickr.image }
    let(:data) { { current: { condition: { icon: icon_url } } } }

    specify { expect(described_class.new(JSON.parse(data.to_json)).icon).to eql(icon_url) }
  end
end