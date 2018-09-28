require 'rspec'
require_relative '../country'



describe 'country' do
  describe 'initalization' do
    it 'does something for a nil example' do
      row = '{| {{RankedMedalTable|class=wikitable sortable}}'
      expect(Country.new(row)).to have_attributes(gold: nil, silver: nil, bronze: nil, raw_name: nil)
    end
    
    it 'works for basic example' do
      row = '| 1 || align=left | {{CHN}} ||54||25||24||103'
      expect(Country.new(row)).to have_attributes(gold: '54', silver: '25', bronze: '24', ioc: 'CHN')
    end
    
    it 'works for flag template' do
      row = '| 7 ||align=left| {{flag|Isle of Wight}} || 11 || 8 || 16 || 35'
      expect(Country.new(row)).to have_attributes(gold: '11', silver: '8', bronze: '16', name: 'Isle of Wight', template: 'flag')
    end
    
    it 'works for a flag template with IOC code' do
      row = '| 7 ||align=left| {{flag|USA}} || 11 || 8 || 16 || 35'
      expect(Country.new(row)).to have_attributes(gold: '11', silver: '8', bronze: '16', name: 'USA', template: 'flag', ioc: 'USA')
    end
    
    it 'works for a non-flag template' do
      row = '| 2 || align=left| {{thprov|CBI}} || 65 || 39 || 54 || 158'
      expect(Country.new(row)).to have_attributes(template: 'thprov')
    end
    
    it 'works for a 2 param flag template' do
      row = '| 31 || align=left | {{flag|Belarus|1995}} ||0||6||11||17'
      expect(Country.new(row)).to have_attributes(gold: '0', silver: '6', bronze: '11', name: 'Belarus', template: 'flag', event: '1995')
    end
    
    describe 'host' do
      it 'is true if row contains host code' do
        row = 'bgcolor=ccccff\n| 2 || align=left| {{thprov|CBI}} || 65 || 39 || 54 || 158'
        expect(Country.new(row)).to have_attributes(host: true)
        expect(Country.new(row).host).to be true
      end
      it 'is false if row does not have host code' do
        row = 'bgcolor=\n| 2 || align=left| {{thprov|CBI}} || 65 || 39 || 54 || 158'
        expect(Country.new(row).host).to be_falsey
      end
    end
  end
  
  describe 'convert_to_ioc' do
    it 'raises an error nil for invalid IOC nation' do
      expect{Country.new('').convert_to_ioc('Pluto')}.to raise_error(Country::InvalidIoc, "Could not convert 'Pluto' to IOC")
    end
    it 'returns USA for United States' do
      expect(Country.new('').convert_to_ioc('United States')).to eq('USA')
    end
  end
  
  
end