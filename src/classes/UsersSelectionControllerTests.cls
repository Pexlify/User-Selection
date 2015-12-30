@isTest
public class UsersSelectionControllerTests {

    @isTest
    static void testInitiallyNoUsersSelectedAndAllUsersContainsAllUsers() {
        SetupData data = new SetupData();
        Test.startTest();
            data.classUnderTest = new UsersSelectionController();
        Test.stopTest();
		System.assertEquals(data.initialUserCount + 10, data.classUnderTest.getAvailableUsers().size());
        System.assertEquals(0, data.classUnderTest.getSelectedUsers().size());
        System.assertEquals(0, data.classUnderTest.selectedUserIds.size());
        System.assertEquals(0, data.classUnderTest.removedUserIds.size());
    }

    @isTest
    static void testOnUserAdditionEverythingWillWorkAsExcepted() {
        SetupData data = new SetupData();
        Test.startTest();
            data.classUnderTest = new UsersSelectionController();
            data.classUnderTest.selectedUserIds.add(data.users[0].id);
            data.classUnderTest.add();
        Test.stopTest();
		System.assertEquals(data.initialUserCount + 9, data.classUnderTest.getAvailableUsers().size());
        System.assertEquals(1, data.classUnderTest.getSelectedUsers().size());
        System.assertEquals(1, data.classUnderTest.selectedUserIds.size());
        System.assertEquals(0, data.classUnderTest.removedUserIds.size());
    }

    @isTest
    static void testOnUserRemovalEverythingWillWorkAsExcepted() {
        SetupData data = new SetupData();
        Test.startTest();
            data.classUnderTest = new UsersSelectionController();
            data.classUnderTest.selectedUserIds.add(data.users[0].id);
            data.classUnderTest.add();
            data.classUnderTest.selectedUserIds = new List<String>();
            data.classUnderTest.removedUserIds.add(data.users[0].id);
            data.classUnderTest.remove();
        Test.stopTest();
		System.assertEquals(data.initialUserCount + 10, data.classUnderTest.getAvailableUsers().size());
        System.assertEquals(0, data.classUnderTest.getSelectedUsers().size());
        System.assertEquals(0, data.classUnderTest.selectedUserIds.size());
        System.assertEquals(1, data.classUnderTest.removedUserIds.size());
    }

    @isTest
    static void testOnMultipleUserAdditionEverythingWillWorkAsExcepted() {
        SetupData data = new SetupData();
        Test.startTest();
            data.classUnderTest = new UsersSelectionController();
            data.classUnderTest.selectedUserIds.add(data.users[0].id);
            data.classUnderTest.selectedUserIds.add(data.users[3].id);
            data.classUnderTest.selectedUserIds.add(data.users[7].id);
            data.classUnderTest.add();
        Test.stopTest();
		System.assertEquals(data.initialUserCount + 7, data.classUnderTest.getAvailableUsers().size());
        System.assertEquals(3, data.classUnderTest.getSelectedUsers().size());
        System.assertEquals(3, data.classUnderTest.selectedUserIds.size());
        System.assertEquals(0, data.classUnderTest.removedUserIds.size());
    }

    @isTest
    static void testOnMultipleUserRemovalEverythingWillWorkAsExcepted() {
        SetupData data = new SetupData();
        Test.startTest();
            data.classUnderTest = new UsersSelectionController();
            data.classUnderTest.selectedUserIds.add(data.users[0].id);
            data.classUnderTest.selectedUserIds.add(data.users[3].id);
            data.classUnderTest.selectedUserIds.add(data.users[7].id);
            data.classUnderTest.add();
            data.classUnderTest.selectedUserIds = new List<String>();
            data.classUnderTest.removedUserIds.add(data.users[0].id);
            data.classUnderTest.removedUserIds.add(data.users[7].id);
            data.classUnderTest.remove();
        Test.stopTest();
		System.assertEquals(data.initialUserCount + 9, data.classUnderTest.getAvailableUsers().size());
        System.assertEquals(1, data.classUnderTest.getSelectedUsers().size());
        System.assertEquals(0, data.classUnderTest.selectedUserIds.size());
        System.assertEquals(2, data.classUnderTest.removedUserIds.size());
    }

    @isTest
    static void testOnSearchAvailableUsersWillBeCroped() {
        SetupData data = new SetupData();
        Test.startTest();
            data.classUnderTest = new UsersSelectionController();
            data.classUnderTest.whereClause = 'TestUniqueLastName2';
            data.classUnderTest.filterAvailableOptions();
        Test.stopTest();
		System.assertEquals(1, data.classUnderTest.getAvailableUsers().size());
        System.assertEquals(0, data.classUnderTest.getSelectedUsers().size());
        System.assertEquals(0, data.classUnderTest.selectedUserIds.size());
        System.assertEquals(0, data.classUnderTest.removedUserIds.size());
    }

    private class SetupData {
		public Integer initialUserCount;
        public List<User> users;
        public UsersSelectionController classUnderTest;

        public SetupData() {
			initialUserCount = [SELECT Count() FROM user WHERE IsActive = true];
            Test.setCurrentPage(Page.UsersSelection);
            users = new List<User>();
            for (Integer i = 0; i < 10; i++) {
                users.add(createUser(i));
            }
            insert users;
        }

        private User createUser(Integer index) {
            return new User(
                    Username = 'test@user.com' + String.valueOf(index) + System.currentTimeMillis(),
                    ProfileId = UserInfo.getProfileId(),
                    Email = 'testEmailUser@forTestTest.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'TestUniqueLastName'+String.valueOf(index),
                    Alias = 'TestUser',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US'
                    );
        }
    }
}