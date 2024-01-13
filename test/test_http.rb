# frozen_string_literal: true

require "test_helper"

class TestHTTP < Minitest::Test
  def test_check_area_with_unsupported_name
    stub_request(:any, /feeds-bosnia-herzegovina/).
      to_return(body: File.read('test/fixtures/bosnia-herzegovina.json'), status: 200)

      expected = JSON.parse(File.read('test/fixtures/bosnia-herzegovina.json'), symbolize_names: true)[:warnings]
      warnings = Meteoalarm::HTTP.call('bosnia-herzegovina')
      assert_equal(expected, warnings)
  end

  def test_check_status_code_404
    stub_request(:any, /feeds-fr/).
      to_return(body: "", status: 404)

    error = assert_raises(Meteoalarm::APIError) do
      Meteoalarm::HTTP.call('france')
    end

    assert_match("The requested page could not be found. Please consider upgrading the Meteoalarm gem or opening an issue.", error.message)
  end

  def test_check_status_code_500
    stub_request(:any, /feeds-bosnia-herzegovina/).
      to_return(body: "", status: 500)

    error = assert_raises(Meteoalarm::APIError) do
      Meteoalarm::HTTP.call('bosnia-herzegovina')
    end

    assert_match("Server error - status code: 500", error.message)
  end

  def test_check_status_code_301
    stub_request(:any, /feeds-bosnia-herzegovina/).to_return(body: "", status: 301)

    error = assert_raises(Meteoalarm::APIError) do
      Meteoalarm::HTTP.call('bosnia-herzegovina')
    end

    assert_match("Server returned unexpected status code: 301", error.message)
  end
end