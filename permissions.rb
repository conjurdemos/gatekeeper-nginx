namespace do 
  bacon = resource 'service', 'bacon'
  
  user "#{namespace}-alice"

  user "#{namespace}-bob" do |bob|
    can "fry", bacon
  end
end