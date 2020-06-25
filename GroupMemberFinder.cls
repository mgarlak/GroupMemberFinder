public with sharing class GroupMemberFinder {

	private static GroupMemberDAI groupMemberAccessor = new GroupMemberDA();
	public static GroupMemberDAI groupMemberAccess {get; set{groupMemberAccessor = value;}}

	private static final SObjectType GROUP_TYPE = Schema.Group.SObjectType;

	private String groupName;

	public GroupMemberFinder(String groupName) {
		this.groupName = groupName;
	}

	public Boolean isUserInGroup(Id userId) {
		List<GroupMember> members = groupMemberAccessor.getMembersByGroupName(groupName);
		List<Id> userMemberIds = getAllSubGroupUserIds(members);
		return userMemberIds.contains(userId);
	}

	private List<Id> getAllSubGroupUserIds(List<GroupMember> members) {
		List<Id> subGroupUserIds = new List<Id>();
		List<Id> groupIds = new List<Id>();
		for (GroupMember member : members) {
			if (member.UserOrGroupId.getSObjectType() == GROUP_TYPE) {
				groupIds.add(member.UserOrGroupId);
			} else {
				subGroupUserIds.add(member.UserOrGroupId);
			}
		}

		if (!groupIds.isEmpty()) {
			List<GroupMember> groupMembers = groupMemberAccessor.getMembersByGroupIds(groupIds);
			subGroupUserIds.addAll(getAllSubGroupUserIds(groupMembers));
		}

		return subGroupUserIds;
	}

}