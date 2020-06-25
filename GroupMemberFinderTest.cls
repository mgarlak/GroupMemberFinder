@isTest
public with sharing class GroupMemberFinderTest {

	private static final String USER_PREFIX = Schema.User.SObjectType.getDescribe().getKeyPrefix();
	private static final String GROUP_PREFIX = Schema.Group.SObjectType.getDescribe().getKeyPrefix();
	private static final String GROUP_MEMBER_PREFIX = Schema.GroupMember.SObjectType.getDescribe().getKeyPrefix();

	@isTest
	private static void isUserInGroup_ShouldReturnTrue_GivenUserIsInTopLevelGroup() {
		User testUser = new User(Id = USER_PREFIX + '000000000001');
		Group testGroup = new Group(Id = GROUP_PREFIX + '000000000001', Name = 'Test Group');
		GroupMember testMember = constructGroupMember(testUser.Id, testGroup);

		GroupMemberDAMock memberMock = new GroupMemberDAMock();
		memberMock.GroupMembers = new List<GroupMember>{testMember};
		GroupMemberFinder.groupMemberAccess = memberMock;

		Boolean isUserInGroup = false;
		Test.startTest();
			GroupMemberFinder finder = new GroupMemberFinder('Test Group');
			isUserInGroup = finder.isUserInGroup(testUser.Id);
		Test.stopTest();

		System.assert(isUserInGroup);
	}

	@isTest
	private static void isUserInGroup_ShouldReturnTrue_GivenUserIsInSubGroup() {
		User testUser = new User(Id = USER_PREFIX + '000000000001');
		Group topGroup = new Group(Id = GROUP_PREFIX + '000000000001', Name = 'Top Group');
		Group subGroup = new Group(Id = GROUP_PREFIX + '000000000002', Name = 'Sub Group');
		GroupMember topMember = constructGroupMember(subGroup.Id, topGroup);
		GroupMember subMember = constructGroupMember(testUser.Id, subGroup);

		GroupMemberDAMock memberMock = new GroupMemberDAMock();
		memberMock.GroupMembers = new List<GroupMember>{topMember, subMember};
		GroupMemberFinder.groupMemberAccess = memberMock;

		Boolean isUserInGroup = false;
		Test.startTest();
			GroupMemberFinder finder = new GroupMemberFinder('Top Group');
			isUserInGroup = finder.isUserInGroup(testUser.Id);
		Test.stopTest();

		System.assert(isUserInGroup);
	}

	@isTest
	private static void isUserInGroup_ShouldReturnFalse_WhenUserIsNotInAnyGroup() {
		User testUser = new User(Id = USER_PREFIX + '000000000001');
		Group topGroup = new Group(Id = GROUP_PREFIX + '000000000001', Name = 'Top Group');
		Group subGroup = new Group(Id = GROUP_PREFIX + '000000000002', Name = 'Sub Group');
		GroupMember topMember = constructGroupMember(subGroup.Id, topGroup);

		GroupMemberDAMock memberMock = new GroupMemberDAMock();
		memberMock.GroupMembers = new List<GroupMember>{topMember};
		GroupMemberFinder.groupMemberAccess = memberMock;

		Boolean isUserInGroup = false;
		Test.startTest();
			GroupMemberFinder finder = new GroupMemberFinder('Top Group');
			isUserInGroup = finder.isUserInGroup(testUser.Id);
		Test.stopTest();

		System.assert(!isUserInGroup);
	}

	private static GroupMember constructGroupMember(Id memberId, Group groupInfo) {
		String memberJSON =  '{"Id":"' + GROUP_MEMBER_PREFIX + '000000000001", "UserOrGroupId":"' + 
								memberId + '", "GroupId":"' + groupInfo.Id + '", "Group":{"Name":"' + groupInfo.Name + '"}}';
		return (GroupMember)JSON.deserialize(memberJSON, GroupMember.class);
	}
}