require 'rails_helper'


def mgp_create_group(description, parent, save=false)
  group = Group.new(
    description: description, 
    parent_id: parent.id
  )
  if save && !parent.children.where(description: description).any?
    group.save()
  else
    group = parent.children.where(description: description)[0]
  end
  group
end

def mgp_create_group_manager(save=false)
  group_manager = GroupManager.new(
    email:'groupmanager' + GroupManager.count.to_s + '@admin.com',
    password:'12345678',
    name: 'jose'
  )
  if save
    group_manager.save()
  end
  group_manager
end

RSpec.describe ManagerGroupPermission, type: :model do
  before :all do
    @root = Group::get_root
    @gp1 = mgp_create_group('group1', @root, save=true)
    @gp2 = mgp_create_group('group2', @root, save=true)
    @gm1 = mgp_create_group_manager(save=true)
    @gm2 = mgp_create_group_manager(save=true)
  end
  
  describe "=> model functions" do
    context '=> valid input' do
      context "=> static functions" do
        it "permit gm* - g1" do
          ManagerGroupPermission::permit(@gm1, @gp1)
          ManagerGroupPermission::permit(@gm2, @gp1)
          ManagerGroupPermission.all.each do |o|
            expect([@gm1,@gm2].include?(o.group_manager)).to eq(true)
            expect(o.group).to eq(@gp1)
          end
        end
        it "permit gm1 and not gm2 with gp1" do
          ManagerGroupPermission::permit(@gm1, @gp1)
          ManagerGroupPermission.all.each do |o|
            expect(o.group_manager).to eq(@gm1)
            expect(o.group).to eq(@gp1)
          end
        end
        it 'unpermit permission' do
          ManagerGroupPermission::permit(@gm1, @gp1)
          ManagerGroupPermission::unpermit(@gm1,@gp1)
          expect(ManagerGroupPermission.count).to eq(0)
        end
        it 'unpermit multiple permissions' do
          ManagerGroupPermission::permit(@gm1, @gp1)
          ManagerGroupPermission::permit(@gm1, @gp1)
          ManagerGroupPermission::permit(@gm1, @gp1)
          ManagerGroupPermission::unpermit(@gm1, @gp1)
          expect(ManagerGroupPermission.count).to eq(0)
        end
        it 'unpermit no permissions' do 
          ManagerGroupPermission::unpermit(@gm1,@gp1)
          expect(ManagerGroupPermission.count).to eq(0)
        end
      end
    end
    context '=> invalid input' do
      context "=> static functions" do
        it "expect permit runtime error from missing group manger" do
          expect{ManagerGroupPermission::permit(nil, @gp1)}
            .to raise_error(RuntimeError, 'Nil group manager')
        end
        it "expect permit runtime error from missing group" do
          expect{ManagerGroupPermission::permit(@gm1, nil)}
            .to raise_error(RuntimeError, 'Nil group')
        end
        it "expect permit runtime error from missing all params" do
          expect{ManagerGroupPermission::permit(nil, nil)}
            .to raise_error(RuntimeError, 'Nil group manager')
        end
        it "expect unpermit runtime error from missing group manger" do
          expect{ManagerGroupPermission::unpermit(nil, @gp1)}
            .to raise_error(RuntimeError, 'Nil group manager')
        end
        it "expect unpermit runtime error from missing group" do
          expect{ManagerGroupPermission::unpermit(@gm1, nil)}
            .to raise_error(RuntimeError, 'Nil group')
        end
        it "expect unpermit runtime error from missing all params" do
          expect{ManagerGroupPermission::unpermit(nil, nil)}
            .to raise_error(RuntimeError, 'Nil group manager')
        end
      end
    end
  end
end
