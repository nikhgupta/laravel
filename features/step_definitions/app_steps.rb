# failure?
Then /^I should( not)? fail (?:in|when|while|for) doing so$/ do |negate|
  step "the stdout should#{negate} contain \"Failed\""
  step "the stdout should not contain \"ERROR\"" if negate
end

# error?
Then /^I should( not)? (?:get|see) an error$/ do |negate|
  step "the stdout should#{negate} contain \"ERROR\""
end

# CLI output
Then /^I should see "(.*?)"$/ do |string|
  step "the stdout should contain \"#{string}\""
end
