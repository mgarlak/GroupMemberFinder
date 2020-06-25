public interface GroupMemberDAI {
	List<GroupMember> getMembersByGroupName(String groupName);
	List<GroupMember> getMembersByGroupIds(List<Id> groupIds);
}