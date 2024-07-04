
trigger LoanApplicationTrigger on Loan_Application__c (after insert) {
    public void verifyDocuments(List<Loan_Application__c> newApplications) {
        List<Document__c> documentsToVerify = new List<Document__c>();
        
        for (Loan_Application__c application : newApplications) {
            // Check if the application has all required documents
            if (application.Identification_Document__c != null && application.Income_Document__c != null && application.Credit_History_Document__c != null && application.Employment_Details_Document__c != null) {
                // Create a new Document__c record for each document submitted
                documentsToVerify.add(new Document__c(
                    Loan_Application__c = application.Id,
                    Document_Type__c = 'Identification',
                    Document_Content__c = application.Identification_Document__c
                ));
                documentsToVerify.add(new Document__c(
                    Loan_Application__c = application.Id,
                    Document_Type__c = 'Income',
                    Document_Content__c = application.Income_Document__c
                ));
                documentsToVerify.add(new Document__c(
                    Loan_Application__c = application.Id,
                    Document_Type__c = 'Credit History',
                    Document_Content__c = application.Credit_History_Document__c
                ));
                documentsToVerify.add(new Document__c(
                    Loan_Application__c = application.Id,
                    Document_Type__c = 'Employment Details',
                    Document_Content__c = application.Employment_Details_Document__c
                ));
            }
        }
        
        // Insert the Document__c records for verification
        insert documentsToVerify;
        
        // Perform document verification and update Loan_Application__c records accordingly
        List<Loan_Application__c> applicationsToUpdate = new List<Loan_Application__c>();
        for (Document__c document : documentsToVerify) {
            if (document.Verification_Status__c == 'Verified') {
                // Update the corresponding Loan_Application__c record
                Loan_Application__c applicationToUpdate = new Loan_Application__c(
                    Id = document.Loan_Application__c,
                    Verification_Status__c = 'Verified',
                    Verification_Date__c = System.today()
                );
                applicationsToUpdate.add(applicationToUpdate);
            } else if (document.Verification_Status__c == 'Flagged') {
                // Update the corresponding Loan_Application__c record
                Loan_Application__c applicationToUpdate = new Loan_Application__c(
                    Id = document.Loan_Application__c,
                    Verification_Status__c = 'Flagged',
                    Verification_Date__c = System.today()
                );
                applicationsToUpdate.add(applicationToUpdate);
            }
        }
        
        // Update the Loan_Application__c records
        update applicationsToUpdate;
    }
    
    // Trigger entry point
    public void afterInsert(List<Loan_Application__c> newApplications, Map<Id, Loan_Application__c> oldApplications) {
        verifyDocuments(newApplications);
    }
}
