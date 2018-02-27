require 'aws-sdk'
#require 'aws'
require 'chef/knife'
class Iamc < Chef::Knife
banner "knife iamc (options)"
option :username,
        :short => '-u username',
        :long => '--username',
        :description => 'name of  the user'
option :group_name,
       :short => '-g groupname',
       :long => '--groupname',
       :description => 'name of the group'
option :option,
       :short => '-o name',
       :long => '--option name',
       :description => 'name of the option'
option :adduser,
       :short => '-a adds user',
       :long => '--adding the user',
       :description => 'adds the user to the group'
option :'list_user_names',
       :short => '-l list users',
        :long => '--list_users',
        :description => 'lists the users'
option :'attach_policy',
       :short => '-p at_policy',
       :long => '--attach_policy',
       :description => 'attaches the policy to group'
option :'detach_policy',
       :short => '-d dt_policy',
       :long => '--detach_policy',
       :description => 'detaches the policy to group'
option :'policyarn',
       :short => '-r policy_arn',
       :long => '--policy_arn',
       :description => 'policy_arn'

option :'databag',
       :short => '-b bag',
       :long => '--data_bag',
       :description => 'creates the data_bag'
def run
        if config[:option] == "create_user"
         @username=config[:username]
         creation(@username)
       elsif config[:option] == "create_group"
         @groupname=config[:group_name]
         group_creation(@groupname)
elsif config[:option] == "delete_user"
@user_name=config[:username]
delete_user
elsif config[:option] == "create_databag"
@bag=config[:databag]
create_databag(@bag)
end
     if config[:adduser]
     @user=config[:username]
@group=config[:group_name]
puts @user
puts @group
         add
  elsif config[:attach_policy]
@g1=config[:group_name]
@policyarn=config[:policyarn]
puts @g1
puts @policyarn
       attach_policy

elsif config[:detach_policy]
@g2=config[:group_name]
@policyarn1=config[:policyarn]
puts @g2
puts @policyarn1
       detach_policy
end
end

def create_databag(bag)
puts "abc"
users = Chef::DataBag.new
users.name("#{@bag}")
users.create
puts "created"
end

def creation(username)

iam = Aws::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')

cr=iam.create_user({ user_name: "#{@username}" })

 puts cr.user.user_name

#user = {
 #"#{@groupname}" => "#{@username}",
  #}
#databag_item = Chef::DataBagItem.new
#databag_item.data_bag('users')
#databag_item.raw_data = user
#databag_item.save
#puts "created databag item"
rescue Aws::IAM::Errors::EntityAlreadyExists
  puts "User '#{@username}' already exists."
end

def group_creation(groupname)
iam = Aws::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-east-1')
gc=iam.create_group({group_name: "#{@groupname}",})
@resp= gc.group.group_name
puts @resp
end

def add
iam = Aws::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')
resp1 = iam.add_user_to_group({
  group_name: "#{@group}",
  user_name: "#{@user}",
})
user = {
'id' => 'names',
 @group => "#{@user}",
  }
databag_item = Chef::DataBagItem.new
databag_item.data_bag('users')
databag_item.raw_data = user
databag_item.save
puts "created databag item"
 puts "User '#{@user}' added to '#{@group}'"
end

def attach_policy
iam = AWS::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')
resp2 = iam.attach_group_policy({
  group_name: "#{@g1}",
  policy_arn: "#{@policyarn}",
})
puts " '#{@policyarn}' attached policy to'#{@g1}' "
end

def detach_policy
iam = AWS::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')
resp3=iam.detach_policy({
group_name: "#{@g2}",
  policy_arn: "#{@policyarn1}",
})
puts " '#{@policyarn1}' detached policy from '#{@g2}' "
end
def delete_user
iam = Aws::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')
resp3=iam.delete_user({
  user_name: "#{@user_name}", # required
})
puts "'#{@user_name}' has been deleted"
user = {
  'id' => "#{@username}",
  }



puts "deleted databag item"

end
end

