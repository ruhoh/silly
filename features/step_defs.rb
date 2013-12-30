Transform(/^(should|should NOT)$/) do |matcher|
  matcher.downcase.gsub(' ', '_')
end

When(/^I query the path "(.*?)"$/) do |term|
  query.path(term)
end

When(/^I query the path_all "(.*?)"$/) do |term|
  query.path_all(term)
end

When(/^I sort the query by "(.*?)" "(.*?)"$/) do |attribute, order|
  query.sort([attribute, order])
end

When(/^I filter the query with:$/) do |json|
  query.where(JSON.parse(json))
end

When(/^this query returns the ordered results "(.*?)"$/) do |results|
  results = results.split(/[\s,]+/).map(&:strip)
  query.map{ |a| a["id"] }.should == results
end

When(/^this query's first result should have the data:$/) do |json|
  data = JSON.parse(json)
  result = query.first
  result.data.should == data
end

When(/^I append the path "(.*?)" to the query$/) do |path|
  query.append_path(File.join(SampleSitePath, path))
end

Given(/^a config file with value:$/) do |string|
  make_config(JSON.parse(string))
end

Given(/^a config file with values:$/) do |table|
  data = table.rows_hash
  data.each{ |key, value| data[key] = JSON.parse(value) }
  make_config(data)
end

Given(/^the file "(.*)" with body:$/) do |file, body|
  make_file(path: file, body: body)
end

Given(/^some files with values:$/) do |table|
  table.hashes.each do |row|
    file = row['file'] ; row.delete('file')
    body = row['body'] ; row.delete('body')

    make_file(path: file, data: row, body: body)
  end
end
