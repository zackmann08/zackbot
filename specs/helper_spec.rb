require './spec_helper'

describe 'get_wmf_pages' do
  #TODO: use VCR!
  it 'raises an error for no results' do
    url = "https://petscan.wmflabs.org/?psid=6000630&format=json"
    expect{Helper.get_wmf_pages(url)}.to raise_error(Helper::NoResults)
  end
end