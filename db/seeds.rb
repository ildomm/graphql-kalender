require 'factory_bot'

if Source.count.zero?
  Source.create!(
      name: 'gorki',
      url: 'https://gorki.de',
      config: '{"page_format":"/en/programme/%Y/%m/all","driver":"nokogiri","xpath":"//*[@id=\"block-gorki-content\"]/div[1]/*","url":"a|href","title":"a|title","dates":"a|href|/"}'
      )

  Source.create!(
      name: 'berglain',
      url: 'http://berghain.de',
      config: '{"page_format":"/events/%Y-%m","driver":"nokogiri","xpath":"//h4","url":"a|href","title":"a|span","dates":"a"}'
  )
end
