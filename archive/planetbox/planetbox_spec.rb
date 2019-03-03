require 'rspec'
require_relative './anetbox'


include Generic
describe 'planetbox' do
  describe 'check_for_plus_minus' do
    it 'works for a reused reference' do
      val = '2.10 ± 0.02<ref name="Gregory2010"/>'
      expect(check_for_plus_minus(val)).to eq(['2.10|±|0.02','<ref name="Gregory2010"/>'])
    end
    
    it 'works for a full reference' do
      val = '2.10 ± 0.02<ref>
{{cite web
 |title=Planets Table
 |url=http://exoplanets.org/planets.shtml
 |work=[[Catalog of Nearby Exoplanets]]
 |accessdate=2008-10-04
| archiveurl= https://web.archive.org/web/20080921002236/http://exoplanets.org/planets.shtml| archivedate= 21 September 2008 <!--DASHBot-->| deadurl= no}}</ref>'
      expect(check_for_plus_minus(val)).to eq(['2.10|±|0.02','<ref>
{{cite web
 |title=Planets Table
 |url=http://exoplanets.org/planets.shtml
 |work=[[Catalog of Nearby Exoplanets]]
 |accessdate=2008-10-04
| archiveurl= https://web.archive.org/web/20080921002236/http://exoplanets.org/planets.shtml| archivedate= 21 September 2008 <!--DASHBot-->| deadurl= no}}</ref>'])
    end    
  end
  describe 'parse_mass' do
    it 'works for just jupiter' do
      params = {'planet_mass' => '123'}
      expect(parse_mass(params)).to eq('123 {{Jupiter mass|link=y}}')
    end
    it 'works for just earth' do
      params = {'mass_earth' => '123'}
      expect(parse_mass(params)).to eq('123 {{Earth mass|link=y}}')
    end
    
    it 'works for both' do
      params = {'mass_earth' => '123', 'planet_mass' => '789'}
      expect(parse_mass(params)).to eq('789 {{Jupiter mass|link=y}}<br>(123 {{Earth mass|link=y}})')
    end
    it 'works for neither' do
      params = {}
      expect(parse_mass(params)).to eq('')
    end
  end
  describe 'parse_apastron' do
    
    it 'works for AU plus/minus' do
      params = {'apastron' => '2.10 ± 0.02<ref name="Gregory2010"/>'}
      expect(parse_apastron(params)).to eq('{{convert|2.10|±|0.02|AU|km|abbr=on}}<ref name="Gregory2010"/>')
    end
    it 'works for GM plus/minus' do
      params = {'apastron_gm' => '123±12.123'}
      expect(parse_apastron(params)).to eq('{{convert|123|±|12.123|Gm|abbr=on}}')
    end
    it 'works for just AU' do
      params = {'apastron' => '123'}
      expect(parse_apastron(params)).to eq('{{convert|123|AU|km|abbr=on}}')
    end
    it 'works for just GM' do
      params = {'apastron_gm' => '789'}
      expect(parse_apastron(params)).to eq('{{convert|789|Gm|abbr=on}}')
    end
    
    it 'works for both' do
      params = {'apastron' => '123', 'apastron_gm' => '789'}
      expect(parse_apastron(params)).to eq('{{convert|123|AU|km|abbr=on}}')
    end
    
    it 'works for not a number' do
      params = {'apastron' => '4.0{{±|0.2|0.5}}'}
      expect(parse_apastron(params)).to eq('4.0{{±|0.2|0.5}} [[astronomical unit|AU]]')
    end
    it 'works for neither' do
      params = {}
      expect(parse_apastron(params)).to eq('')
    end
  end
  describe 'parse_periastron' do
    it 'works for just AU' do
      params = {'periastron' => '123'}
      expect(parse_periastron(params)).to eq('{{convert|123|AU|km|abbr=on}}')
    end
    it 'works for just GM' do
      params = {'periastron_gm' => '789'}
      expect(parse_periastron(params)).to eq('{{convert|789|Gm|abbr=on}}')
    end
    
    it 'works for both' do
      params = {'periastron' => '123', 'periastron_gm' => '789'}
      expect(parse_periastron(params)).to eq('{{convert|123|AU|km|abbr=on}}')
    end
    it 'works for neither' do
      params = {}
      expect(parse_periastron(params)).to eq('')
    end
  end
  
  describe 'parse_gravity' do
    
    it 'works for just gravity' do
      params = {'gravity' => '123±987'}
      expect(parse_gravity(params)).to eq('{{convert|123|±|987|m/s2|lk=on|abbr=on}}')
    end
    it 'works for just earth' do
      params = {'gravity_earth' => '123 ± 789'}
      expect(parse_gravity(params)).to eq('123 ± 789 [[g-force|g]]')
    end
    it 'works for both' do
      params = {'gravity' => '123±345', 'gravity_earth' => '789 ± 54'}
      expect(parse_gravity(params)).to eq('{{convert|123|±|345|m/s2|lk=on|abbr=on}}<br>789 ± 54 [[g-force|g]]')
    end
    it 'works for neither' do
      params = {}
      expect(parse_gravity(params)).to eq('')
    end
  end
  describe 'parse_density' do
    it 'works for just kg' do
      params = {'density' => '123'}
      expect(parse_density(params)).to eq('{{convert|123|kg/m3|lk=on|abbr=on}}')
    end
    it 'works for just g' do
      params = {'density_cgs' => '234'}
      expect(parse_density(params)).to eq('{{convert|234|g/cm3|lk=on|abbr=on}}')
    end
    it 'works for neither' do
      params = {}
      expect(parse_density(params)).to eq('')
    end
  end
  describe 'parse_radius' do
    it 'works for all 3' do
      params = {'planet_radius' => '123', 'radius_earth' => '456', 'radius_megameter' => '789' }
      expect(parse_radius(params)).to eq('123 {{Jupiter radius|link=y}}<br>456 {{Earth radius|link=y}}<br>{{convert|789|Mm|lk=on|abbr=on}}')
    end
    it 'works for 2' do
      params = {'radius_earth' => '456', 'radius_megameter' => '789' }
      expect(parse_radius(params)).to eq('456 {{Earth radius|link=y}}<br>{{convert|789|Mm|lk=on|abbr=on}}')
    end
    it 'works just 1' do
      params = {'planet_radius' => '123'}
      expect(parse_radius(params)).to eq('123 {{Jupiter radius|link=y}}')
    end
    it 'works for none' do
      params = {}
      expect(parse_radius(params)).to eq('')
    end
  end
  describe 'parse_period' do
    it 'works for all 3' do
      params = {'period' => '123', 'period_year' => '456', 'period_hour' => '789' }
      expect(parse_period(params)).to eq('123 [[day|d]]<br>456 [[year|y]]<br>789 [[hour|h]]')
    end
    it 'works for 2' do
      params = {'period_year' => '456', 'period_hour' => '789' }
      expect(parse_period(params)).to eq('456 [[year|y]]<br>789 [[hour|h]]')
    end
    it 'works just 1' do
      params = {'period_hour' => '123'}
      expect(parse_period(params)).to eq('123 [[hour|h]]')
    end
    it 'works for none' do
      params = {}
      expect(parse_period(params)).to eq('')
    end
  end
  describe 'parse_semimajor' do
    it 'works for all 3' do
      params = {'semimajor' => '123', 'semimajor_gm' => '456', 'semimajor_mas' => '789' }
      expect(parse_semimajor(params)).to eq('{{convert|123|AU|km|abbr=on}}')
    end
    it 'works for 2' do
      params = {'semimajor_gm' => '456', 'semimajor_mas' => '789' }
      expect(parse_semimajor(params)).to eq('{{convert|456|Gm|abbr=on}}')
    end
    it 'works just 1' do
      params = {'semimajor_mas' => '123'}
      expect(parse_semimajor(params)).to eq('123 [[Minute and second of arc|mas]]')
    end
    it 'works for none' do
      params = {}
      expect(parse_semimajor(params)).to eq('')
    end
  end

end