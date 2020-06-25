@isTest
public with sharing class GroupMemberDAMock implements GroupMemberDAI {
	
	public List<GroupMember> GroupMembers = new List<GroupMember>();

	public List<GroupMember> getMembersByGroupName(String groupName) {
		List<GroupMember> membersInGroup = new List<GroupMember>();
		for (GroupMember member : GroupMembers) {
			if (member.Group.Name == groupName) {
				membersInGroup.add(member);
			}
		}
		return membersInGroup;
	}

	public List<GroupMember> getMembersByGroupIds(List<Id> groupIds) {
		List<GroupMember> membersInGroup = new List<GroupMember>();
		for (GroupMember member : GroupMembers) {
			if (groupIds.contains(member.GroupId)) {
				membersInGroup.add(member);
			}
		}
		return membersInGroup;
	}

}