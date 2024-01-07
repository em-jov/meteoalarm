# frozen_string_literal: true

require "test_helper"

class TestMeteoalarm < Minitest::Test
  def teardown
    Timecop.return
  end

  def test_that_it_has_a_version_number
    refute_nil ::Meteoalarm::VERSION
  end

  def test_alerts_method_with_valid_country_and_area
    expected = {"alert"=>
                {"identifier"=>"2.49.0.0.70.0.BA.240107075519.77799897",
                "incidents"=>"Alert",
                "info"=>
                  [{"area"=>[{"areaDesc"=>"Sarajevo", "geocode"=>[{"value"=>"BA006", "valueName"=>"EMMA_ID"}]}],
                    "category"=>["Met"],
                    "certainty"=>"Likely",
                    "description"=>"Min temperature up to -6°C.",
                    "effective"=>"2024-01-07T07:55:19+01:00",
                    "event"=>"Low-temperature Yellow Warning",
                    "expires"=>"2024-01-10T10:00:59+01:00",
                    "headline"=>"Low-temperature Yellow Warning for Bosnia and Herzegovina - region Sarajevo",
                    "instruction"=>
                    "Be aware that low air temperatures are expected. There are possible health risks among the vulnerable population, for example, the elderly and very young people and the homeless.",
                    "language"=>"en",
                    "onset"=>"2024-01-10T00:00:00+01:00",
                    "parameter"=>[{"value"=>"2; yellow; Moderate", "valueName"=>"awareness_level"}, {"value"=>"6; low-temperature", "valueName"=>"awareness_type"}],
                    "responseType"=>["Monitor"],
                    "senderName"=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                    "severity"=>"Moderate",
                    "urgency"=>"Future",
                    "web"=>"http://www.fhmzbih.gov.ba/latinica/"},
                  {"area"=>[{"areaDesc"=>"Sarajevo", "geocode"=>[{"value"=>"BA006", "valueName"=>"EMMA_ID"}]}],
                    "category"=>["Met"],
                    "certainty"=>"Likely",
                    "description"=>"Min temperatura oko -6 °C.",
                    "effective"=>"2024-01-07T07:55:19+01:00",
                    "event"=>"Niska temperatura žuto Upozorenje",
                    "expires"=>"2024-01-10T10:00:59+01:00",
                    "headline"=>"Niska temperatura žuto Upozorenje za Bosnu i Hercegovinu - region Sarajevo",
                    "instruction"=>
                    "Budite svjesni da se očekuju niske temperature zraka. Mogući su zdravstveni rizici među ugroženom populacijom, na primjer, starije i veoma mlade osobe i beskućnici.",
                    "language"=>"bs",
                    "onset"=>"2024-01-10T00:00:00+01:00",
                    "parameter"=>[{"value"=>"2; yellow; Moderate", "valueName"=>"awareness_level"}, {"value"=>"6; low-temperature", "valueName"=>"awareness_type"}],
                    "responseType"=>["Monitor"],
                    "senderName"=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                    "severity"=>"Moderate",
                    "urgency"=>"Future",
                    "web"=>"http://www.fhmzbih.gov.ba/latinica/"}],
                "msgType"=>"Alert",
                "scope"=>"Public",
                "sender"=>"sinoptika@fhmzbih.gov.ba",
                "sent"=>"2024-01-07T07:55:19+01:00",
                "status"=>"Actual"},
              "uuid"=>"44ab5cb6-6d10-43e3-a474-ce2014ccddde"}

    stub_request(:any, /feeds-bosnia-herzegovina/).
      to_return(body: File.read('test/fixtures/bosnia-herzegovina.json'), status: 200)

    # Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alerts('bosnia-herzegovina', area: 'Sarajevo')
    assert_equal(expected, warnings.first)
  end

  def test_alerts_method_with_valid_country_and_area_with_coordinates
    expected = {"alert"=>
                {"identifier"=>"2.49.0.0.70.0.BA.240107075519.77799897",
                "incidents"=>"Alert",
                "info"=>
                  [{"area"=>[{"areaDesc"=>"Sarajevo", "geocode"=>[{"value"=>"BA006", "valueName"=>"EMMA_ID"}]}],
                    "category"=>["Met"],
                    "certainty"=>"Likely",
                    "description"=>"Min temperature up to -6°C.",
                    "effective"=>"2024-01-07T07:55:19+01:00",
                    "event"=>"Low-temperature Yellow Warning",
                    "expires"=>"2024-01-10T10:00:59+01:00",
                    "headline"=>"Low-temperature Yellow Warning for Bosnia and Herzegovina - region Sarajevo",
                    "instruction"=>
                    "Be aware that low air temperatures are expected. There are possible health risks among the vulnerable population, for example, the elderly and very young people and the homeless.",
                    "language"=>"en",
                    "onset"=>"2024-01-10T00:00:00+01:00",
                    "parameter"=>[{"value"=>"2; yellow; Moderate", "valueName"=>"awareness_level"}, {"value"=>"6; low-temperature", "valueName"=>"awareness_type"}],
                    "responseType"=>["Monitor"],
                    "senderName"=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                    "severity"=>"Moderate",
                    "urgency"=>"Future",
                    "web"=>"http://www.fhmzbih.gov.ba/latinica/"},
                  {"area"=>[{"areaDesc"=>"Sarajevo", "geocode"=>[{"value"=>"BA006", "valueName"=>"EMMA_ID"}]}],
                    "category"=>["Met"],
                    "certainty"=>"Likely",
                    "description"=>"Min temperatura oko -6 °C.",
                    "effective"=>"2024-01-07T07:55:19+01:00",
                    "event"=>"Niska temperatura žuto Upozorenje",
                    "expires"=>"2024-01-10T10:00:59+01:00",
                    "headline"=>"Niska temperatura žuto Upozorenje za Bosnu i Hercegovinu - region Sarajevo",
                    "instruction"=>
                    "Budite svjesni da se očekuju niske temperature zraka. Mogući su zdravstveni rizici među ugroženom populacijom, na primjer, starije i veoma mlade osobe i beskućnici.",
                    "language"=>"bs",
                    "onset"=>"2024-01-10T00:00:00+01:00",
                    "parameter"=>[{"value"=>"2; yellow; Moderate", "valueName"=>"awareness_level"}, {"value"=>"6; low-temperature", "valueName"=>"awareness_type"}],
                    "responseType"=>["Monitor"],
                    "senderName"=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                    "severity"=>"Moderate",
                    "urgency"=>"Future",
                    "web"=>"http://www.fhmzbih.gov.ba/latinica/"}],
                "msgType"=>"Alert",
                "scope"=>"Public",
                "sender"=>"sinoptika@fhmzbih.gov.ba",
                "sent"=>"2024-01-07T07:55:19+01:00",
                "status"=>"Actual"},
              "uuid"=>"44ab5cb6-6d10-43e3-a474-ce2014ccddde"}

    stub_request(:any, /feeds-bosnia-herzegovina/).
      to_return(body: File.read('test/fixtures/bosnia-herzegovina.json'), status: 200)

    # Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alerts('bosnia-herzegovina', latitude: 43.852276, longitude: 18.396182)
    assert_equal(expected, warnings.first)
  end

  def test_alerts_method_with_invalid_country
    stub_request(:any, /feeds-invalid_country/).to_return(status: 404)
    
    error = assert_raises(Meteoalarm::Error) do
      Meteoalarm::Client.alerts('invalid_country')
    end

    assert_match('Unsupported country name was specified', error.message)
  end

  def test_alerts_method_with_valid_country_and_area_with_multipolygons
    expected = {"alert"=>
                {"identifier"=>"2.49.0.0.191.0.HR.240106140208_0_orange_HR804",
                "incidents"=>"Alert",
                "info"=>
                  [{"area"=>[{"areaDesc"=>"North Dalmatia region", "geocode"=>[{"value"=>"HR804", "valueName"=>"EMMA_ID"}]}],
                    "category"=>["Met"],
                    "certainty"=>"Possible",
                    "description"=>"Jaka, mjestimice vrlo jaka bura. Najjači udari vjetra 35-60 čvorova  (65-110 km/h)",
                    "effective"=>"2024-01-06T14:02:08+01:00",
                    "event"=>"Narančasto upozorenje za vjetar",
                    "expires"=>"2024-01-08T23:59:59+01:00",
                    "instruction"=>
                    "UTJECAJ: Očekujte i budite pripravni za olujne brzine vjetra u kombinaciji s lokalno visokim valovima koji su se već ili će se tek generirati. Upravljanje plovilom u tim uvjetima zahtijeva veliko iskustvo te adekvatno opremljena plovila.\n" +
                    "Preporučljivo je da pomorci bez odgovarajućeg iskustva potraže  sigurnu luku prije početka potencijalno opasnog vjetra i valova. Vjerojatno je da mnogi katamarani i trajekti neće ploviti pa ako putujete, pratite informacije o prometu.",
                    "language"=>"hr-HR",
                    "onset"=>"2024-01-08T00:01:01+01:00",
                    "parameter"=>[{"value"=>"3; orange; Severe", "valueName"=>"awareness_level"}, {"value"=>"1; Wind", "valueName"=>"awareness_type"}],
                    "responseType"=>["Monitor"],
                    "senderName"=>"DHMZ Državni hidrometeorološki zavod",
                    "severity"=>"Severe",
                    "urgency"=>"Future"},
                  {"area"=>[{"areaDesc"=>"North Dalmatia region", "geocode"=>[{"value"=>"HR804", "valueName"=>"EMMA_ID"}]}],
                    "category"=>["Met"],
                    "certainty"=>"Possible",
                    "description"=>"Strong, locally near gale NE wind. Maximum wind gusts 35-60 knots  (65-110 km/h)",
                    "effective"=>"2024-01-06T14:02:08+01:00",
                    "event"=>"Orange wind warning",
                    "expires"=>"2024-01-08T23:59:59+01:00",
                    "instruction"=>
                    "IMPACT: Be prepared for gale and strong gale wind speeds combined with locally high waves that are imminent or occurring. Operating a vessel in these conditions requires experience and properly equipped vessels.\n" +
                    "It is highly recommended that mariners without the proper experience seek safe harbor prior to onset of potentially dangerous wind and wave conditions. It is likely that many ferries will not operate so follow traffic information if travelling.",
                    "language"=>"en-GB",
                    "onset"=>"2024-01-08T00:01:01+01:00",
                    "parameter"=>[{"value"=>"3; orange; Severe", "valueName"=>"awareness_level"}, {"value"=>"1; Wind", "valueName"=>"awareness_type"}],
                    "responseType"=>["Monitor"],
                    "senderName"=>"DHMZ Državni hidrometeorološki zavod",
                    "severity"=>"Severe",
                    "urgency"=>"Future"}],
                "msgType"=>"Alert",
                "scope"=>"Public",
                "sender"=>"https://meteo.hr",
                "sent"=>"2024-01-06T14:02:08+01:00",
                "status"=>"Actual"},
              "uuid"=>"e940aab4-98f3-4935-8fdc-ed67415e06b7"}

    stub_request(:any, /feeds-croatia/).
      to_return(body: File.read('test/fixtures/croatia.json'), status: 200)

    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alerts('croatia', area: 'North Dalmatia region')
    assert_equal(expected, warnings.first)
    assert_equal(2, warnings.count)
  end

  def test_alerts_method_with_valid_country_and_area_with_exipred_alarms
    stub_request(:any, /feeds-croatia/).
      to_return(body: File.read('test/fixtures/croatia.json'), status: 200)

    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alerts('croatia', area: 'North Dalmatia region', expired: true)
    assert_equal(4, warnings.count)
  end

  def test_currently_active_alarms
    expected = [{"alert"=>
                  {"identifier"=>"2.49.0.0.70.0.BA.240106080313.30892745",
                  "incidents"=>"Alert",
                  "info"=>
                    [{"area"=>[{"areaDesc"=>"Tuzla", "geocode"=>[{"value"=>"BA004", "valueName"=>"EMMA_ID"}]}],
                      "category"=>["Met"],
                      "certainty"=>"Likely",
                      "description"=>"Accumulated rain between 15 and 25 l/m2.",
                      "effective"=>"2024-01-06T08:03:13+01:00",
                      "event"=>"Rain Yellow Warning",
                      "expires"=>"2024-01-07T23:59:59+01:00",
                      "headline"=>"Rain Yellow Warning for Bosnia and Herzegovina - region Tuzla",
                      "instruction"=>
                      "Be aware of the possibility of local flooding of a small number of properties, with local disruption to outdoor activities. Difficult driving conditions due to reduced visibility and uncontrolled movement of vehicles due to water.",
                      "language"=>"en",
                      "onset"=>"2024-01-07T00:00:00+01:00",
                      "parameter"=>[{"value"=>"2; yellow; Moderate", "valueName"=>"awareness_level"}, {"value"=>"10; Rain", "valueName"=>"awareness_type"}],
                      "responseType"=>["Monitor"],
                      "senderName"=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                      "severity"=>"Moderate",
                      "urgency"=>"Future",
                      "web"=>"http://www.fhmzbih.gov.ba/latinica/"},
                    {"area"=>[{"areaDesc"=>"Tuzla", "geocode"=>[{"value"=>"BA004", "valueName"=>"EMMA_ID"}]}],
                      "category"=>["Met"],
                      "certainty"=>"Likely",
                      "description"=>"Očekivana količina padavina između 15 i 25 l/m2-",
                      "effective"=>"2024-01-06T08:03:13+01:00",
                      "event"=>"Kiša žuto Upozorenje",
                      "expires"=>"2024-01-07T23:59:59+01:00",
                      "headline"=>"Kiša žuto Upozorenje za Bosnu i Hercegovinu - region Tuzla",
                      "instruction"=>
                      "Budite svjesni mogućnosti za lokalno plavljenje manjeg broja imovine, sa lokalnim ometanjem u aktivnostima na otvorenom. Teški uslovi za vožnju uslijed smanjenje vidljivosti i nekontrolisanog kretanja vozila uslijed vode.",
                      "language"=>"bs",
                      "onset"=>"2024-01-07T00:00:00+01:00",
                      "parameter"=>[{"value"=>"2; yellow; Moderate", "valueName"=>"awareness_level"}, {"value"=>"10; Rain", "valueName"=>"awareness_type"}],
                      "responseType"=>["Monitor"],
                      "senderName"=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                      "severity"=>"Moderate",
                      "urgency"=>"Future",
                      "web"=>"http://www.fhmzbih.gov.ba/latinica/"}],
                  "msgType"=>"Alert",
                  "scope"=>"Public",
                  "sender"=>"sinoptika@fhmzbih.gov.ba",
                  "sent"=>"2024-01-06T08:03:13+01:00",
                  "status"=>"Actual"},
                "uuid"=>"f7e4c461-78b8-49e1-9663-2648ff52b173"}]

    stub_request(:any, /feeds-bosnia-herzegovina/).
    to_return(body: File.read('test/fixtures/bosnia-herzegovina.json'), status: 200)

    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alerts('bosnia-herzegovina', area: 'Tuzla', active_now: true)
    assert_equal(expected, warnings)
  end

  def test_alarms_filter_by_date
    expected = [{"alert"=>
                  {"identifier"=>"2.49.0.0.70.0.BA.240106081136.40030908",
                  "incidents"=>"Alert",
                  "info"=>
                    [{"area"=>[{"areaDesc"=>"Tuzla", "geocode"=>[{"value"=>"BA004", "valueName"=>"EMMA_ID"}]}],
                      "category"=>["Met"],
                      "certainty"=>"Likely",
                      "description"=>"Min temperature up to -6°C.",
                      "effective"=>"2024-01-06T08:11:36+01:00",
                      "event"=>"Low-temperature Yellow Warning",
                      "expires"=>"2024-01-09T11:00:59+01:00",
                      "headline"=>"Low-temperature Yellow Warning for Bosnia and Herzegovina - region Tuzla",
                      "instruction"=>"Be aware that low air temperatures are expected. There are possible health risks among the vulnerable population, for example, the elderly and very young people and the homeless.",
                      "language"=>"en",
                      "onset"=>"2024-01-09T00:00:00+01:00",
                      "parameter"=>[{"value"=>"2; yellow; Moderate", "valueName"=>"awareness_level"}, {"value"=>"6; low-temperature", "valueName"=>"awareness_type"}],
                      "responseType"=>["Monitor"],
                      "senderName"=>"Hydrometeorological Institute of Federation of Bosnia and Herzegovina",
                      "severity"=>"Moderate",
                      "urgency"=>"Future",
                      "web"=>"http://www.fhmzbih.gov.ba/latinica/"},
                    {"area"=>[{"areaDesc"=>"Tuzla", "geocode"=>[{"value"=>"BA004", "valueName"=>"EMMA_ID"}]}],
                      "category"=>["Met"],
                      "certainty"=>"Likely",
                      "description"=>"Min temperatura oko -6 °C.",
                      "effective"=>"2024-01-06T08:11:36+01:00",
                      "event"=>"Niska temperatura žuto Upozorenje",
                      "expires"=>"2024-01-09T11:00:59+01:00",
                      "headline"=>"Niska temperatura žuto Upozorenje za Bosnu i Hercegovinu - region Tuzla",
                      "instruction"=>"Budite svjesni da se očekuju niske temperature zraka. Mogući su zdravstveni rizici među ugroženom populacijom, na primjer, starije i veoma mlade osobe i beskućnici.",
                      "language"=>"bs",
                      "onset"=>"2024-01-09T00:00:00+01:00",
                      "parameter"=>[{"value"=>"2; yellow; Moderate", "valueName"=>"awareness_level"}, {"value"=>"6; low-temperature", "valueName"=>"awareness_type"}],
                      "responseType"=>["Monitor"],
                      "senderName"=>"Federalni hidrometeorološki zavod Federacije Bosne i Hercegovine",
                      "severity"=>"Moderate",
                      "urgency"=>"Future",
                      "web"=>"http://www.fhmzbih.gov.ba/latinica/"}],
                  "msgType"=>"Alert",
                  "scope"=>"Public",
                  "sender"=>"sinoptika@fhmzbih.gov.ba",
                  "sent"=>"2024-01-06T08:11:36+01:00",
                  "status"=>"Actual"},
                "uuid"=>"d47845cd-a8d0-4c21-a481-e06ad18b8582"}]

    stub_request(:any, /feeds-bosnia-herzegovina/).
    to_return(body: File.read('test/fixtures/bosnia-herzegovina.json'), status: 200)

    Timecop.freeze(Time.local(2024, 1, 7, 17, 00, 0))

    warnings = Meteoalarm::Client.alerts('bosnia-herzegovina', area: 'Tuzla', date: '2024-01-09')
    assert_equal(expected, warnings)
  end 
end
