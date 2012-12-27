When /install generator for this application$/ do
  step "I run `laravel install generator --app=#{@app_path}`"
end

Then /^(?:|a )tasks? should be installed as "(.*?)"$/ do |filename|
  filepath = @app_tester.app.tasks_file(filename)
  @app_tester.raise_error?(File.exists?(filepath))
  step "the stdout should contain \"Installed task\""
end
