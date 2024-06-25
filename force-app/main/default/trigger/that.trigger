
trigger LoanApplicationTrigger on Loan_Application__c (after insert, after update) {
    // Check if the loan application status has changed
    List<Loan_Application__c> updatedApplications = new List<Loan_Application__c>();
    for (Loan_Application__c application : Trigger.new) {
        Loan_Application__c oldApplication = Trigger.oldMap.get(application.Id);
        if (application.Status__c != oldApplication.Status__c) {
            updatedApplications.add(application);
        }
    }
    
    // Update the loan application status in real-time
    if (!updatedApplications.isEmpty()) {
        List<Loan_Application__c> applicationsToUpdate = new List<Loan_Application__c>();
        for (Loan_Application__c application : updatedApplications) {
            application.Last_Status_Update__c = DateTime.now();
            applicationsToUpdate.add(application);
        }
        update applicationsToUpdate;
    }
}
