public with sharing class GroupMemberDA implements GroupMemberDAI {

    public List<GroupMember> getMembersByGroupName(String groupName) {
        return [SELECT Id, UserOrGroupId, GroupId
                FROM GroupMember
                WHERE Group.Name = :groupName];
    }

	public List<GroupMember> getMembersByGroupIds(List<Id> groupIds) {
        return [SELECT Id, UserOrGroupId, GroupId
                FROM GroupMember
                WHERE GroupId IN :groupIds];
    }
}