/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Your Name
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        Account account =  new Account(Name = 'Test Account22');
        insert account;
        return  account.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        insert new Account(Name = name, Industry = industry);
    }


    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        Contact contact = new  Contact(AccountId = accountId, LastName = 'Test Contact');
        insert contact;
        return contact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        Contact contact =  [SELECT Id FROM Contact WHERE Id = :contactId][0];
        contact.LastName = newLastName;
        update contact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        Opportunity opportunity =  [SELECT Id FROM Opportunity WHERE Id = :oppId][0];
        opportunity.StageName = newStage;
        update opportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        Account account =  [SELECT Id FROM Account WHERE Id = :accountId][0];
        account.Name = newName;
        account.Industry = newIndustry;
        update account;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Iterate over the opportunities
        // Set the Opportunity's Stage to Qualification
        // Set the Opportunity's Close Date to 3 months from today
        // Set the Opportunity's Amount to 50000
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for(Opportunity opp : opportunities){
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
            opportunitiesToUpdate.add(opp);
        }
        upsert opportunitiesToUpdate;
        // Upsert the Opportunity
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Loop through each Opportunity name
        // Create an Opportunity with the given name
        // Add the Opportunity to the list
        Account account = new Account(Name = accountName);
        insert account;
        List<Opportunity> opportunities = new List<Opportunity>();
        for(String oppName : oppNames){
         Opportunity opp = new Opportunity(Name = oppName, AccountId = account.Id, StageName = 'Qualification', CloseDate = Date.today().addMonths(3), Amount = 50000);
            opportunities.add(opp);
        }
        upsert opportunities;
        // Upsert the Opportunities
    }

    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
    public static Account upsertAccount(String accountName) {
        // Query for the Account
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];

        // if the Account exists, update the description
        if(accounts.size() > 0){
            Account account = accounts[0];
            account.Description = 'Updated Account';
            update account;
            return account;
        }
        // otherwise, create a new Account and set the description
        Account newAccount = new Account(Name = accountName, Description = 'New Account');
        // Upsert the Account
        upsert newAccount;
        return newAccount;
    }

    /**
     * Question 10
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Create or use existing account with contact last name. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
	 * Contacts are then linked to these accounts based on a full last name match.
     * Example Contact Last Name = Doe Link to Account Name = Doe
     * Example Contact Last Name = Jane Link to Account Name = Jane
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
    public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
        // Loop through each Contact

        // Extract the Account Name from Contact's LastName
        for(Contact contact : contactsToUpsert){
           Account account = upsertAccount(contact.LastName);
            contact.AccountId = account.Id;

        }
        // Get the account based on the name or create one if it doesn't exist
        // Link the Contact to its Account using the Account Id

        upsert contactsToUpsert;
    }

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name
        List<Lead> leads = new List<Lead>();
        for(String leadName : leadNames){
            Lead lead = new Lead(FirstName = leadName, LastName = 'Test Lead', Company = 'Test Company');
            leads.add(lead);
        }
        insert leads;
        delete leads;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        List<Case> cases = new List<Case>();
        // Insert the cases
        while (numOfCases > 0){
            Case newCase = new Case(AccountId = accountId, Subject = 'Test Case');
            cases.add(newCase);
            numOfCases--;
        }
        insert cases;
        delete cases;
        // Delete the cases
    }
}