Here is an example of a Salesforce trigger code that can be used to automate the loan disbursement process:

trigger LoanDisbursementTrigger on Loan__c (after update) {
    List<Loan__c> approvedLoans = new List<Loan__c>();
    
    for (Loan__c loan : Trigger.new) {
        if (loan.Status__c == 'Approved' && Trigger.oldMap.get(loan.Id).Status__c != 'Approved') {
            approvedLoans.add(loan);
        }
    }
    
    if (!approvedLoans.isEmpty()) {
        List<Disbursement__c> disbursements = new List<Disbursement__c>();
        
        for (Loan__c approvedLoan : approvedLoans) {
            Disbursement__c disbursement = new Disbursement__c();
            disbursement.Loan__c = approvedLoan.Id;
            disbursement.Recipient__c = approvedLoan.Recipient__c;
            disbursement.Amount__c = approvedLoan.Amount__c;
            disbursement.DisbursementDate__c = System.today();
            
            disbursements.add(disbursement);
        }
        
        insert disbursements;
        
        // Send confirmation notification to bank and recipient
        // Code for sending notification goes here
        
        // Log disbursement details for auditing purposes
        // Code for logging details goes here
    }
}

This trigger code will be executed after a Loan record is updated. It checks if the loan status has changed to 'Approved' from any other status. If so, it creates a new Disbursement record with the loan details and inserts it into the database.

After the disbursements are inserted, you can add code to send confirmation notifications to the bank and recipient, as well as log the disbursement details for auditing purposes. Additionally, you can handle any disbursement errors or failures by adding appropriate error handling and alerting the bank loan officer.

Please note that this is a basic example and you may need to modify the code to fit your specific requirements and business logic.