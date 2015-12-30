public class UsersSelectionController {
    public List<String> selectedUserIds { get; set; }
    public List<String> removedUserIds { get; set; }
    public String whereClause { get; set; }
    private Map<Id, String> availableUsersMap;
    private Map<Id, String> selectedUsersMap;

    public UsersSelectionController() {
        initializeCollections();
        getUsers();
    }

    public void filterAvailableOptions() {
        availableUsersMap = new Map<Id, String>();
        selectedUserIds = new List<String>();
        String likeClause = '%' + whereClause + '%';
        for (User u : [SELECT id, name FROM User WHERE name like :likeClause]) {
            if (!selectedUsersMap.containsKey(u.Id)) {
                availableUsersMap.put(u.Id, u.Name);
            }
        }
    }

    public void add() {
        if (!selectedUserIds.isEmpty()) {
            for (String userId : selectedUserIds) {
                selectedUsersMap.put(userId, availableUsersMap.get(userId));
                availableUsersMap.remove(userId);
            }
        }
    }

    public void remove() {
        if (!removedUserIds.isEmpty()) {
            for (String userId : removedUserIds) {
                availableUsersMap.put(userId, selectedUsersMap.get(userId));
                selectedUsersMap.remove(userId);
            }
        }
    }

    public List<SelectOption> getAvailableUsers() {
        List<SelectOption> availableUsers = new List<SelectOption>();
        for (Id userId : availableUsersMap.keySet()) {
            availableUsers.add(new SelectOption(userId, availableUsersMap.get(userId)));
        }
        return availableUsers;
    }

    public List<SelectOption> getSelectedUsers() {
        List<SelectOption> selectedUsers = new List<SelectOption>();
        for (String userId : selectedUsersMap.keySet()) {
            selectedUsers.add(new SelectOption(userId, selectedUsersMap.get(userId)));
        }
        return selectedUsers;
    }

    private void initializeCollections() {
        selectedUserIds = new List<String>();
        removedUserIds = new List<String>();
        availableUsersMap = new Map<Id, String>();
        selectedUsersMap = new Map<Id, String>();
    }

    private void getUsers() {
        for (User u : [SELECT id, name FROM user WHERE IsActive = true]) {
            availableUsersMap.put(u.Id, u.Name);
        }
    }
}