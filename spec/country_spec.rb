require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ISO3166::Country do

  let(:country) { ISO3166::Country.search('US') }

  it 'should return 3166 number' do
    country.number.should == '840'
  end

  it 'should return 3166 alpha2 code' do
    country.alpha2.should == 'US'
  end

  it 'should return 3166 alpha3 code' do
    country.alpha3.should == 'USA'
  end

  it 'should return 3166 name' do
    country.name.should == 'United States'
  end

  it 'should return alternate names' do
    country.names.should == ["United States of America", "Vereinigte Staaten von Amerika", "États-Unis", "Estados Unidos"]
  end

  it 'should return latitude' do
    country.latitude.should == '38 00 N'
  end

  it 'should return longitude' do
    country.longitude.should == '97 00 W'
  end

  it 'should return region' do
    country.region.should == 'Americas'
  end

  it 'should return subregion' do
    country.subregion.should == 'Northern America'
  end

  describe 'e164' do
    it 'should return country_code' do
      country.country_code.should == '1'
    end

    it 'should return national_destination_code_lengths' do
      country.national_destination_code_lengths.should == [3]
    end

    it 'should return national_number_lengths' do
      country.national_number_lengths.should == [10]
    end

    it 'should return international_prefix' do
      country.international_prefix.should == '011'
    end

    it 'should return national_prefix' do
      country.national_prefix.should == '1'
    end
  end

  describe 'subdivisions' do
    it 'should return an empty hash for a country with no ISO3166-2' do
      ISO3166::Country.search('VA').subdivisions.should have(0).subdivisions
    end

    it 'should return a hash with all sub divisions' do
      country.subdivisions.should have(57).states
    end

    it 'should be available through states' do
      country.states.should have(57).states
    end
  end

  describe 'search' do
    it 'should return new country object when a valid alpha2 is passed' do
      ISO3166::Country.search('US').should be_a(ISO3166::Country)
    end
  end

  describe 'currency' do
    it 'should return an instance of Currency' do
      country.currency.should be_a(ISO4217::Currency)
    end

    it 'should allow access to symbol' do
      country.currency[:symbol].should == '$'
    end    
  end

  describe "Country class" do
    context "when loaded via 'iso3166' existance" do
      subject { defined?(Country) }

      it { should be_false }
    end

    context "when loaded via 'countries'" do
      before { require 'countries' }

      describe "existance" do
        subject { defined?(Country) }

        it { should be_true }
      end

      describe "superclass" do
        subject { Country.superclass }

        it { should == ISO3166::Country }
      end
    end
  end

  describe ".find_by_name" do
    context "when search name in 'name'" do
      before { @country = ISO3166::Country.find_by_name("Poland") }

      it "should return a Country instance" do
        @country.should be_a_kind_of(ISO3166::Country)
      end
      it "should be Poland" do
        @country.alpha2.should == "PL"
      end
    end

    context "when search name in 'names'" do
      before { @country = ISO3166::Country.find_by_name("Polonia") }

      it "should return a Country instance" do
        @country.should be_a_kind_of(ISO3166::Country)
      end
      it "should be Poland" do
        @country.alpha2.should == "PL"
      end
    end
  end

  describe "names in Data" do
    it "should be unique (to allow .find_by_name work properly)" do
      names = ISO3166::Country::Data.collect do |k,v|
        [v["name"], v["names"]].flatten.uniq
      end.flatten

      names.size.should == names.uniq.size
    end
  end
  
  describe 'Norway' do
    let(:norway) { ISO3166::Country.search('NO') }
    
    it 'should have a currency' do
      norway.currency.should be_a(ISO4217::Currency)
    end
  end

end
