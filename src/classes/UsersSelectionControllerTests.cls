@isTest
public class UsersSelectionControllerTests {

    @isTest
    static void testInitiallyNoUsersSelectedAndAllUsersContainsAllUsers() {
        SetupData data = new SetupData();
        Test.startTest();
            System.runAs(data.runningUser) {
                data.classUnderTest = new UsersSelectionController();
            }
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
            System.runAs(data.runningUser) {
                data.classUnderTest = new UsersSelectionController();
                data.classUnderTest.selectedUserIds.add(data.users[0].id);
                data.classUnderTest.add();
            }
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
            System.runAs(data.runningUser) {
                data.classUnderTest = new UsersSelectionController();
                data.classUnderTest.selectedUserIds.add(data.users[0].id);
                data.classUnderTest.add();
                data.classUnderTest.selectedUserIds = new List<String>();
                data.classUnderTest.removedUserIds.add(data.users[0].id);
                data.classUnderTest.remove();
            }
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
            System.runAs(data.runningUser) {
                data.classUnderTest = new UsersSelectionController();
                data.classUnderTest.selectedUserIds.add(data.users[0].id);
                data.classUnderTest.selectedUserIds.add(data.users[3].id);
                data.classUnderTest.selectedUserIds.add(data.users[7].id);
                data.classUnderTest.add();
            }
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
            System.runAs(data.runningUser) {
                data.classUnderTest = new UsersSelectionController();
                data.classUnderTest.selectedUserIds.add(data.users[0].id);
                data.classUnderTest.selectedUserIds.add(data.users[3].id);
                data.classUnderTest.selectedUserIds.add(data.users[7].id);
                data.classUnderTest.add();
                data.classUnderTest.selectedUserIds = new List<String>();
                data.classUnderTest.removedUserIds.add(data.users[0].id);
                data.classUnderTest.removedUserIds.add(data.users[7].id);
                data.classUnderTest.remove();
            }
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
            System.runAs(data.runningUser) {
                data.classUnderTest = new UsersSelectionController();
                data.classUnderTest.whereClause = 'TestUniqueLastName2';
                data.classUnderTest.filterAvailableOptions();
            }
        Test.stopTest();
        System.assertEquals(1, data.classUnderTest.getAvailableUsers().size());
        System.assertEquals(0, data.classUnderTest.getSelectedUsers().size());
        System.assertEquals(0, data.classUnderTest.selectedUserIds.size());
        System.assertEquals(0, data.classUnderTest.removedUserIds.size());
    }

    private class SetupData {
        public User runningUser;
        public Integer initialUserCount;
        public List<User> users;
        public UsersSelectionController classUnderTest;

        public SetupData() {
            createRunningUser();
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

        private void createRunningUser() {
            runningUser = new User();
            String random_email = generateRandomString(20) + '@' + generateRandomString(10) + '.com';
            runningUser.Username = random_email;
            runningUser.Email = random_email;
            String random_string = generateRandomString(8);
            runningUser.LastName = random_string;
            runningUser.Alias = random_string;
            runningUser.CommunityNickname = random_string;
            runningUser.TimeZoneSidKey = 'GMT';
            runningUser.LocaleSidKey = 'en_US';
            runningUser.EmailEncodingKey = 'UTF-8';
            runningUser.LanguageLocaleKey = 'en_US';
            String profile_id = [SELECT Name, Id FROM Profile WHERE Name = 'Standard User' LIMIT 1][0].id;
            runningUser.ProfileId = profile_id;
            insert runningUser;
        }

        private String generateRandomString(Integer length_of_string) {
            final String possible_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
            String random_string = '';
            while (random_string.length() < length_of_string) {
               Integer index_of_random_char = Math.mod(Math.abs(Crypto.getRandomInteger()), possible_chars.length());
               random_string += possible_chars.substring(index_of_random_char, index_of_random_char + 1);
            }
            return random_string; 
        }
    }
}