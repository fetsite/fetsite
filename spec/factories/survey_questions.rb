FactoryGirl.define do
  factory :survey_question, :class => 'Survey::Question' do
    title "MyString"
text "MyText"
typ 1
  end

end
