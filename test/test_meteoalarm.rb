# frozen_string_literal: true

require "test_helper"

class TestMeteoalarm < Minitest::Test
  def teardown
    Timecop.return
  end

  def test_that_it_has_a_version_number
    refute_nil ::Meteoalarm::VERSION
  end

  def test_alarms_method_with_valid_country_and_area
    expected = {:alert=>
                {:identifier=>"2.49.0.0.70.0.BA.240107075519.77799897",
                :incidents=>"Alert",
                :info=>
                  [{:area=>[{:areaDesc=>"Sarajevo", :geocode=>[{:value=>"BA006", :valueName=>"EMMA_ID"}]}],
                    :category=>["Met"],
                    :certainty=>"Likely",
                    :description=>"Min temperature up to -6°C.",
                    :effective=>"2024-01-07T07:55:19+01:00",
                    :event=>"Low-temperature Yellow Warning",
                    :expires=>"2024-01-10T10:00:59+01:00",
                    :headline=>"Low-temperature Yellow Warning for Bosnia and Herzegovina - region Sarajevo",
                    :instruction=>
                    "Be aware that low air temperatures are expected. There are possible health risks among the vulnerable population, for example, the elderly and very young people and the homeless.",
                    :language=>"en",
                    :onset=>"2024-01-10T00:00:00+01:00",
                    :parameter=>
                    [{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"},
                      {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                    :responseType=>["Monitor"],
                    :senderName=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                    :severity=>"Moderate",
                    :urgency=>"Future",
                    :web=>"http://www.fhmzbih.gov.ba/latinica/"},
                  {:area=>[{:areaDesc=>"Sarajevo", :geocode=>[{:value=>"BA006", :valueName=>"EMMA_ID"}]}],
                    :category=>["Met"],
                    :certainty=>"Likely",
                    :description=>"Min temperatura oko -6 °C.",
                    :effective=>"2024-01-07T07:55:19+01:00",
                    :event=>"Niska temperatura žuto Upozorenje",
                    :expires=>"2024-01-10T10:00:59+01:00",
                    :headline=>"Niska temperatura žuto Upozorenje za Bosnu i Hercegovinu - region Sarajevo",
                    :instruction=>
                    "Budite svjesni da se očekuju niske temperature zraka. Mogući su zdravstveni rizici među ugroženom populacijom, na primjer, starije i veoma mlade osobe i beskućnici.",
                    :language=>"bs",
                    :onset=>"2024-01-10T00:00:00+01:00",
                    :parameter=>
                    [{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"},
                      {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                    :responseType=>["Monitor"],
                    :senderName=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                    :severity=>"Moderate",
                    :urgency=>"Future",
                    :web=>"http://www.fhmzbih.gov.ba/latinica/"}],
                :msgType=>"Alert",
                :scope=>"Public",
                :sender=>"sinoptika@fhmzbih.gov.ba",
                :sent=>"2024-01-07T07:55:19+01:00",
                :status=>"Actual"},
              :uuid=>"44ab5cb6-6d10-43e3-a474-ce2014ccddde"}

    Meteoalarm::HTTP.expects(:call).with('bosnia-herzegovina').
      returns(JSON.parse(File.read('test/fixtures/bosnia-herzegovina.json'), symbolize_names: true)[:warnings])

    Timecop.freeze(Time.local(2024, 1, 9, 17, 00, 0))

    warnings = Meteoalarm::Client.alarms('ba', area: 'Sarajevo')
    assert_equal(expected, warnings.first)
  end

  def test_alarms_method_with_valid_country_and_area_with_coordinates
    expected = {:alert=>
                {:identifier=>"2.49.0.0.70.0.BA.240107075519.77799897",
                :incidents=>"Alert",
                :info=>
                  [{:area=>[{:areaDesc=>"Sarajevo", :geocode=>[{:value=>"BA006", :valueName=>"EMMA_ID"}]}],
                    :category=>["Met"],
                    :certainty=>"Likely",
                    :description=>"Min temperature up to -6°C.",
                    :effective=>"2024-01-07T07:55:19+01:00",
                    :event=>"Low-temperature Yellow Warning",
                    :expires=>"2024-01-10T10:00:59+01:00",
                    :headline=>"Low-temperature Yellow Warning for Bosnia and Herzegovina - region Sarajevo",
                    :instruction=>
                    "Be aware that low air temperatures are expected. There are possible health risks among the vulnerable population, for example, the elderly and very young people and the homeless.",
                    :language=>"en",
                    :onset=>"2024-01-10T00:00:00+01:00",
                    :parameter=>
                    [{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"},
                      {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                    :responseType=>["Monitor"],
                    :senderName=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                    :severity=>"Moderate",
                    :urgency=>"Future",
                    :web=>"http://www.fhmzbih.gov.ba/latinica/"},
                  {:area=>[{:areaDesc=>"Sarajevo", :geocode=>[{:value=>"BA006", :valueName=>"EMMA_ID"}]}],
                    :category=>["Met"],
                    :certainty=>"Likely",
                    :description=>"Min temperatura oko -6 °C.",
                    :effective=>"2024-01-07T07:55:19+01:00",
                    :event=>"Niska temperatura žuto Upozorenje",
                    :expires=>"2024-01-10T10:00:59+01:00",
                    :headline=>"Niska temperatura žuto Upozorenje za Bosnu i Hercegovinu - region Sarajevo",
                    :instruction=>
                    "Budite svjesni da se očekuju niske temperature zraka. Mogući su zdravstveni rizici među ugroženom populacijom, na primjer, starije i veoma mlade osobe i beskućnici.",
                    :language=>"bs",
                    :onset=>"2024-01-10T00:00:00+01:00",
                    :parameter=>
                    [{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"},
                      {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                    :responseType=>["Monitor"],
                    :senderName=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                    :severity=>"Moderate",
                    :urgency=>"Future",
                    :web=>"http://www.fhmzbih.gov.ba/latinica/"}],
                :msgType=>"Alert",
                :scope=>"Public",
                :sender=>"sinoptika@fhmzbih.gov.ba",
                :sent=>"2024-01-07T07:55:19+01:00",
                :status=>"Actual"},
              :uuid=>"44ab5cb6-6d10-43e3-a474-ce2014ccddde"}

    Meteoalarm::HTTP.expects(:call).with('bosnia-herzegovina').
      returns(JSON.parse(File.read('test/fixtures/bosnia-herzegovina.json'), symbolize_names: true)[:warnings])

    Timecop.freeze(Time.local(2024, 1, 9, 17, 00, 0))  

    warnings = Meteoalarm::Client.alarms('ba', latitude: 43.852276, longitude: 18.396182)
    assert_equal(expected, warnings.first)
  end

  def test_alarms_method_with_invalid_country_code  
    error = assert_raises(Meteoalarm::ArgumentError) do
      Meteoalarm::Client.alarms('xyz')
    end

    assert_match('The provided country code is not supported. Refer to the rake tasks to view a list of available country codes.', error.message)
  end

  def test_alarms_method_with_valid_country_and_area_with_multipolygons
    # skip
    expected = {:alert=>
                {:identifier=>"2.49.0.0.191.0.HR.240107082021_0_yellow_HR008",
                :incidents=>"Alert",
                :info=>
                  [{:area=>[{:areaDesc=>"Split region", :geocode=>[{:value=>"HR008", :valueName=>"EMMA_ID"}]}],
                    :category=>["Met"],
                    :certainty=>"Likely",
                    :description=>"Mjestimice jako jugo u okretanju na buru s olujnim udarima. najjači udar vjetra > 65 km/h",
                    :effective=>"2024-01-07T08:20:21+01:00",
                    :event=>"Žuto upozorenje za vjetar",
                    :expires=>"2024-01-07T23:59:59+01:00",
                    :instruction=>"BUDITE NA OPREZU zbog krhotina koje lete nošene jakim vjetrom. Mogući su lokalizirani prekidi u aktivnostima na otvorenom.",
                    :language=>"hr-HR",
                    :onset=>"2024-01-07T09:00:00+01:00",
                    :parameter=>[{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, {:value=>"1; Wind", :valueName=>"awareness_type"}],
                    :responseType=>["Monitor"],
                    :senderName=>"DHMZ Državni hidrometeorološki zavod",
                    :severity=>"Moderate",
                    :urgency=>"Future"},
                  {:area=>[{:areaDesc=>"Split region", :geocode=>[{:value=>"HR008", :valueName=>"EMMA_ID"}]}],
                    :category=>["Met"],
                    :certainty=>"Likely",
                    :description=>"Locally strong jugo (SE) wind turning to bura (NE) with gale force gusts. maximum gust speed > 65 km/h",
                    :effective=>"2024-01-07T08:20:21+01:00",
                    :event=>"Yellow wind warning",
                    :expires=>"2024-01-07T23:59:59+01:00",
                    :instruction=>"STAY ALERT for debris carried by strong winds. Debris and tree branches carried by the wind may cause localised interruptions in outdoor activities.",
                    :language=>"en-GB",
                    :onset=>"2024-01-07T09:00:00+01:00",
                    :parameter=>[{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, {:value=>"1; Wind", :valueName=>"awareness_type"}],
                    :responseType=>["Monitor"],
                    :senderName=>"DHMZ Državni hidrometeorološki zavod",
                    :severity=>"Moderate",
                    :urgency=>"Future"}],
                :msgType=>"Alert",
                :scope=>"Public",
                :sender=>"https://meteo.hr",
                :sent=>"2024-01-07T08:20:21+01:00",
                :status=>"Actual"},
              :uuid=>"8829dadd-8ce7-455a-8500-7ad46053f97a"}

    Meteoalarm::HTTP.expects(:call).with('croatia').
      returns(JSON.parse(File.read('test/fixtures/croatia.json'), symbolize_names: true)[:warnings])

    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alarms('hr', latitude: 43.5153279, longitude: 16.4363667)

    assert_equal(expected, warnings.first)
  end

  def test_alarms_method_with_valid_country_and_area_with_expired_alarms
    Meteoalarm::HTTP.expects(:call).with('croatia').
      returns(JSON.parse(File.read('test/fixtures/croatia.json'), symbolize_names: true)[:warnings])  

    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alarms('hr', area: 'North Dalmatia region', expired: true)
    assert_equal(4, warnings.count)
  end

  def test_currently_active_alarms
    expected = [{:alert=>
                 {:identifier=>"2.49.0.0.70.0.BA.240106080313.30892745",
                  :incidents=>"Alert",
                  :info=>
                    [{:area=>[{:areaDesc=>"Tuzla", :geocode=>[{:value=>"BA004", :valueName=>"EMMA_ID"}]}],
                      :category=>["Met"],
                      :certainty=>"Likely",
                      :description=>"Accumulated rain between 15 and 25 l/m2.",
                      :effective=>"2024-01-06T08:03:13+01:00",
                      :event=>"Rain Yellow Warning",
                      :expires=>"2024-01-07T23:59:59+01:00",
                      :headline=>"Rain Yellow Warning for Bosnia and Herzegovina - region Tuzla",
                      :instruction=>
                      "Be aware of the possibility of local flooding of a small number of properties, with local disruption to outdoor activities. Difficult driving conditions due to reduced visibility and uncontrolled movement of vehicles due to water.",
                      :language=>"en",
                      :onset=>"2024-01-07T00:00:00+01:00",
                      :parameter=>
                      [{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, {:value=>"10; Rain", :valueName=>"awareness_type"}],
                      :responseType=>["Monitor"],
                      :senderName=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                      :severity=>"Moderate",
                      :urgency=>"Future",
                      :web=>"http://www.fhmzbih.gov.ba/latinica/"},
                    {:area=>[{:areaDesc=>"Tuzla", :geocode=>[{:value=>"BA004", :valueName=>"EMMA_ID"}]}],
                      :category=>["Met"],
                      :certainty=>"Likely",
                      :description=>"Očekivana količina padavina između 15 i 25 l/m2-",
                      :effective=>"2024-01-06T08:03:13+01:00",
                      :event=>"Kiša žuto Upozorenje",
                      :expires=>"2024-01-07T23:59:59+01:00",
                      :headline=>"Kiša žuto Upozorenje za Bosnu i Hercegovinu - region Tuzla",
                      :instruction=>
                      "Budite svjesni mogućnosti za lokalno plavljenje manjeg broja imovine, sa lokalnim ometanjem u aktivnostima na otvorenom. Teški uslovi za vožnju uslijed smanjenje vidljivosti i nekontrolisanog kretanja vozila uslijed vode.",
                      :language=>"bs",
                      :onset=>"2024-01-07T00:00:00+01:00",
                      :parameter=>
                      [{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, {:value=>"10; Rain", :valueName=>"awareness_type"}],
                      :responseType=>["Monitor"],
                      :senderName=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                      :severity=>"Moderate",
                      :urgency=>"Future",
                      :web=>"http://www.fhmzbih.gov.ba/latinica/"}],
                  :msgType=>"Alert",
                  :scope=>"Public",
                  :sender=>"sinoptika@fhmzbih.gov.ba",
                  :sent=>"2024-01-06T08:03:13+01:00",
                  :status=>"Actual"},
                :uuid=>"f7e4c461-78b8-49e1-9663-2648ff52b173"}]

    Meteoalarm::HTTP.expects(:call).with('bosnia-herzegovina').
      returns(JSON.parse(File.read('test/fixtures/bosnia-herzegovina.json'), symbolize_names: true)[:warnings])

    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alarms('ba', area: 'Tuzla', active_now: true)
    assert_equal(expected, warnings)
  end

  def test_future_alarms
    expected = [{:alert=>
                  {:identifier=>"2.49.0.0.70.0.BA.240106081136.40030908",
                  :incidents=>"Alert",
                  :info=>
                    [{:area=>[{:areaDesc=>"Tuzla", :geocode=>[{:value=>"BA004", :valueName=>"EMMA_ID"}]}],
                      :category=>["Met"],
                      :certainty=>"Likely",
                      :description=>"Min temperature up to -6°C.",
                      :effective=>"2024-01-06T08:11:36+01:00",
                      :event=>"Low-temperature Yellow Warning",
                      :expires=>"2024-01-09T11:00:59+01:00",
                      :headline=>"Low-temperature Yellow Warning for Bosnia and Herzegovina - region Tuzla",
                      :instruction=>
                      "Be aware that low air temperatures are expected. There are possible health risks among the vulnerable population, for example, the elderly and very young people and the homeless.",
                      :language=>"en",
                      :onset=>"2024-01-09T00:00:00+01:00",
                      :parameter=>[{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                      :responseType=>["Monitor"],
                      :senderName=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                      :severity=>"Moderate",
                      :urgency=>"Future",
                      :web=>"http://www.fhmzbih.gov.ba/latinica/"},
                    {:area=>[{:areaDesc=>"Tuzla", :geocode=>[{:value=>"BA004", :valueName=>"EMMA_ID"}]}],
                      :category=>["Met"],
                      :certainty=>"Likely",
                      :description=>"Min temperatura oko -6 °C.",
                      :effective=>"2024-01-06T08:11:36+01:00",
                      :event=>"Niska temperatura žuto Upozorenje",
                      :expires=>"2024-01-09T11:00:59+01:00",
                      :headline=>"Niska temperatura žuto Upozorenje za Bosnu i Hercegovinu - region Tuzla",
                      :instruction=>
                      "Budite svjesni da se očekuju niske temperature zraka. Mogući su zdravstveni rizici među ugroženom populacijom, na primjer, starije i veoma mlade osobe i beskućnici.",
                      :language=>"bs",
                      :onset=>"2024-01-09T00:00:00+01:00",
                      :parameter=>[{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                      :responseType=>["Monitor"],
                      :senderName=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                      :severity=>"Moderate",
                      :urgency=>"Future",
                      :web=>"http://www.fhmzbih.gov.ba/latinica/"}],
                  :msgType=>"Alert",
                  :scope=>"Public",
                  :sender=>"sinoptika@fhmzbih.gov.ba",
                  :sent=>"2024-01-06T08:11:36+01:00",
                  :status=>"Actual"},
                :uuid=>"d47845cd-a8d0-4c21-a481-e06ad18b8582"},
                {:alert=>
                  {:identifier=>"2.49.0.0.70.0.BA.240107075519.75445725",
                  :incidents=>"Alert",
                  :info=>
                    [{:area=>[{:areaDesc=>"Tuzla", :geocode=>[{:value=>"BA004", :valueName=>"EMMA_ID"}]}],
                      :category=>["Met"],
                      :certainty=>"Likely",
                      :description=>"Min temperature up to -6°C.",
                      :effective=>"2024-01-07T07:55:19+01:00",
                      :event=>"Low-temperature Yellow Warning",
                      :expires=>"2024-01-10T10:00:59+01:00",
                      :headline=>"Low-temperature Yellow Warning for Bosnia and Herzegovina - region Tuzla",
                      :instruction=>
                      "Be aware that low air temperatures are expected. There are possible health risks among the vulnerable population, for example, the elderly and very young people and the homeless.",
                      :language=>"en",
                      :onset=>"2024-01-10T00:00:00+01:00",
                      :parameter=>[{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                      :responseType=>["Monitor"],
                      :senderName=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                      :severity=>"Moderate",
                      :urgency=>"Future",
                      :web=>"http://www.fhmzbih.gov.ba/latinica/"},
                    {:area=>[{:areaDesc=>"Tuzla", :geocode=>[{:value=>"BA004", :valueName=>"EMMA_ID"}]}],
                      :category=>["Met"],
                      :certainty=>"Likely",
                      :description=>"Min temperatura oko -6 °C.",
                      :effective=>"2024-01-07T07:55:19+01:00",
                      :event=>"Niska temperatura žuto Upozorenje",
                      :expires=>"2024-01-10T10:00:59+01:00",
                      :headline=>"Niska temperatura žuto Upozorenje za Bosnu i Hercegovinu - region Tuzla",
                      :instruction=>
                      "Budite svjesni da se očekuju niske temperature zraka. Mogući su zdravstveni rizici među ugroženom populacijom, na primjer, starije i veoma mlade osobe i beskućnici.",
                      :language=>"bs",
                      :onset=>"2024-01-10T00:00:00+01:00",
                      :parameter=>[{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"}, {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                      :responseType=>["Monitor"],
                      :senderName=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                      :severity=>"Moderate",
                      :urgency=>"Future",
                      :web=>"http://www.fhmzbih.gov.ba/latinica/"}],
                  :msgType=>"Alert",
                  :scope=>"Public",
                  :sender=>"sinoptika@fhmzbih.gov.ba",
                  :sent=>"2024-01-07T07:55:19+01:00",
                  :status=>"Actual"},
                :uuid=>"b3a1e1d0-7e73-496a-b657-141eec73e5b7"}]

    Meteoalarm::HTTP.expects(:call).with('bosnia-herzegovina').
      returns(JSON.parse(File.read('test/fixtures/bosnia-herzegovina.json'), symbolize_names: true)[:warnings])

    Timecop.freeze(Time.local(2024, 1, 8, 17, 00, 0))

    warnings = Meteoalarm::Client.alarms('ba', area: 'Tuzla', future_alarms: true)
    assert_equal(expected, warnings)
  end

  def test_alarms_filter_by_date
    expected = [{:alert=>
                 {:identifier=>"2.49.0.0.70.0.BA.240106081136.40030908",
                  :incidents=>"Alert",
                  :info=>
                    [{:area=>[{:areaDesc=>"Tuzla", :geocode=>[{:value=>"BA004", :valueName=>"EMMA_ID"}]}],
                      :category=>["Met"],
                      :certainty=>"Likely",
                      :description=>"Min temperature up to -6°C.",
                      :effective=>"2024-01-06T08:11:36+01:00",
                      :event=>"Low-temperature Yellow Warning",
                      :expires=>"2024-01-09T11:00:59+01:00",
                      :headline=>"Low-temperature Yellow Warning for Bosnia and Herzegovina - region Tuzla",
                      :instruction=>
                      "Be aware that low air temperatures are expected. There are possible health risks among the vulnerable population, for example, the elderly and very young people and the homeless.",
                      :language=>"en",
                      :onset=>"2024-01-09T00:00:00+01:00",
                      :parameter=>
                      [{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"},
                        {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                      :responseType=>["Monitor"],
                      :senderName=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                      :severity=>"Moderate",
                      :urgency=>"Future",
                      :web=>"http://www.fhmzbih.gov.ba/latinica/"},
                    {:area=>[{:areaDesc=>"Tuzla", :geocode=>[{:value=>"BA004", :valueName=>"EMMA_ID"}]}],
                      :category=>["Met"],
                      :certainty=>"Likely",
                      :description=>"Min temperatura oko -6 °C.",
                      :effective=>"2024-01-06T08:11:36+01:00",
                      :event=>"Niska temperatura žuto Upozorenje",
                      :expires=>"2024-01-09T11:00:59+01:00",
                      :headline=>"Niska temperatura žuto Upozorenje za Bosnu i Hercegovinu - region Tuzla",
                      :instruction=>
                      "Budite svjesni da se očekuju niske temperature zraka. Mogući su zdravstveni rizici među ugroženom populacijom, na primjer, starije i veoma mlade osobe i beskućnici.",
                      :language=>"bs",
                      :onset=>"2024-01-09T00:00:00+01:00",
                      :parameter=>
                      [{:value=>"2; yellow; Moderate", :valueName=>"awareness_level"},
                        {:value=>"6; low-temperature", :valueName=>"awareness_type"}],
                      :responseType=>["Monitor"],
                      :senderName=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                      :severity=>"Moderate",
                      :urgency=>"Future",
                      :web=>"http://www.fhmzbih.gov.ba/latinica/"}],
                  :msgType=>"Alert",
                  :scope=>"Public",
                  :sender=>"sinoptika@fhmzbih.gov.ba",
                  :sent=>"2024-01-06T08:11:36+01:00",
                  :status=>"Actual"},
                :uuid=>"d47845cd-a8d0-4c21-a481-e06ad18b8582"}]

    Meteoalarm::HTTP.expects(:call).with('bosnia-herzegovina').
      returns(JSON.parse(File.read('test/fixtures/bosnia-herzegovina.json'), symbolize_names: true)[:warnings])

    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alarms('ba', area: 'Tuzla', date: Date.new(2024, 1, 9))
    assert_equal(expected, warnings)
  end 

  def test_alarms_filter_by_date_set_in_past
    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    error = assert_raises(Meteoalarm::ArgumentError) do
      Meteoalarm::Client.alarms('ba', area: 'Tuzla', date: Date.new(2024, 1, 6))
    end

    assert_match('The date must be set in the future.', error.message)
  end 

  def test_check_area_with_unsupported_name
    Meteoalarm::HTTP.expects(:call).with('bosnia-herzegovina').
      returns(JSON.parse(File.read('test/fixtures/bosnia-herzegovina.json'), symbolize_names: true)[:warnings])

    error = assert_raises(Meteoalarm::ArgumentError) do
      Meteoalarm::Client.alarms('ba', area: 'xyz')
    end

    assert_match('The provided area name is not supported. Refer to the rake tasks to view a list of available area names.', error.message)
  end
end

