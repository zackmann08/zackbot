require 'rspec'
require_relative './param'



describe 'country' do
  describe 'initalization' do
    it 'raises an error for an invalid type' do
      expect{Param.new(type: 'FOO')}.to raise_error(Param::InvalidParam)
    end
    it 'generates a basic record' do
      expect(Param.new(name: 'test_param', label: 'Test Param', 
          description: 'Described', example: 'some example',
          type: 'string', default: 'the default value', required: 'yes'
      )).to have_attributes(
          name: 'test_param', label: 'Test Param',
          description: 'Described', example: 'some example',
          type: 'string', default: 'the default value', required: 'yes'
      )
    end
  end

end