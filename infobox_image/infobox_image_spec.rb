require '../infobox_image/image'
include Image
describe 'parse_image' do
  it 'returns nil if the input does not match regex' do
    expect(parse_image('INVALID')).to be nil
  end
  
  it 'works for just filename and thumb' do
    text = '[[File:testing.jpg|thumb]]'
    expect(parse_image(text)).to eq(['testing.jpg',nil])
    text = '[[File:testing.jpg|thumb|]]'
    expect(parse_image(text)).to eq(['testing.jpg',nil])
  end
  
  it 'works for filename thumb and frameless' do
    text = '[[File:testing.jpg|thumb|frameless]]'
    expect(parse_image(text)).to eq(['testing.jpg',nil])
    text = '[[File:testing.jpg|thumb|frameless|]]'
    expect(parse_image(text)).to eq(['testing.jpg',nil])
  end
  
  it 'works for filename and width' do
    text = '[[File:testing.jpg|thumb|600px]]'
    expect(parse_image(text)).to eq(['testing.jpg',nil])
    text = '[[File:testing.jpg|thumb|600px|]]'
    expect(parse_image(text)).to eq(['testing.jpg',nil])
  end
  
  it 'returns the caption for filename and caption' do
    text = '[[File:testing.jpg|thumb|600px|frameless|This is the caption]]'
    expect(parse_image(text)).to eq(['testing.jpg','This is the caption'])
  end
end