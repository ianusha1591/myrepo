require 'aws-sdk'
require 'chef/knife'
require 'fileutils'
class Update5 < Chef::Knife
banner "knife update5 (options)"
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
option :'databag',
       :short => '-b bag',
       :long => '--data_bag',
       :description => 'creates the data_bag'
option :'dataitem',
       :short => '-i item',
       :long => '--dataitem',
       :description => 'creates the dataitem'
option :'list',
       :short => '-l list',
       :long => '--list',
       :description => 'list the  content'
option :'list',
       :short => '-d delete',
       :long => '--deletion',
       :description => 'deletes the databag'
def run
        if config[:option] == "create_user"
         @username=config[:username]
creation
elsif config[:option] =="create_group"
@groupname=config[:group_name]
group_creation
elsif config[:option] == "create_databag"
@bag=config[:databag]
create_databag
elsif config[:option] == "add"
@groupname=config[:group_name]
 @username=config[:username]

add

elsif config[:option] == "create_dataitem"
@dataitem=config[:dataitem]
@groupname=config[:group_name]
 @username=config[:username]
dataitem
elsif config[:option] == "update"
@groupname=config[:group_name]
 @username=config[:username]
update
elsif config[:option] == "update_databag"
@groupname=config[:group_name]
 @username=config[:username]

update_databag
elsif config[:option] == "list"
list

elsif config[:option] == "delete"
@bag1=config[:databag]
@dataitem1=config[:dataitem]
delete_databag
end
end

def create_databag
item=Chef::DataBag.load('databag9')
   puts(" data bag found")
rescue Net::HTTPServerException => e
   if e.response.code == '404'
   new = Chef::DataBag.new
   new.name('databag9')
   new.save
   puts ("created new data bag")
   end

end

def dataitem
user= ({
  'id'=>'dataitem9',
    })

   item=Chef::DataBagItem.load('databag9','dataitem9')
   puts(" data bag Item found")
  rescue Net::HTTPServerException => e
   if e.response.code == '404'
    item = Chef::DataBagItem.new
       item.data_bag('databag9')
item.raw_data = user
       item.save
   end

end   

def creation

iam = Aws::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')

cr=iam.create_user({ user_name: "#{@username}" })

 puts cr.user.user_name

end

def group_creation
iam = Aws::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')
 gc=iam.create_group({group_name: "#{@groupname}",})
@resp= gc.group.group_name
puts @resp
end

def add
iam = Aws::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')
puts "abc"
resp1 = iam.add_user_to_group({
  group_name: "#{@groupname}",
  user_name: "#{@username}",
})
puts "added"
update_databag
end

def update_databag
item = Chef::DataBagItem.load('databag9','dataitem9')
      puts "abc"
      value = item.raw_data["#{@groupname}"]
      
        if value==nil
       group_key
       update
        else
         puts value
      update
  end
end


def group_key
  item = Chef::DataBagItem.load('databag9','dataitem9')
  val = item.raw_data
  puts val
  item.raw_data["#{@groupname}"] = []
  item.save            
end

def update
item = Chef::DataBagItem.load('databag9','dataitem9')
 value =item.raw_data["#{@groupname}"] 


 update_value = value.push("#{@username}")
 item.raw_data[:"#{@groupname}"]=update_value
 item.save
 puts "updated"

end
def list
item = Chef::DataBagItem.load('databag9','dataitem9')
puts item.raw_data
end
def delete_databag
iam = Aws::IAM::Client.new( access_key_id: 'AKIAID6RQGH5PVQOVDVA',
  secret_access_key: '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',
  region: 'us-west-2')
#item = Chef::DataBagItem.load('databag9','dataitem9')
del = Chef::DataBag.load(@bag1)
puts @bag1

del.delete(@bag1)

puts "d"
end 
end                   
