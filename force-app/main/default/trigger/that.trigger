
trigger CreditCheckPreQualificationTrigger on Applicant__c (after insert, after update) {
    // Trigger logic to perform credit check and pre-qualification
    List<Applicant__c> applicantsToUpdate = new List<Applicant__c>();
    
    for (Applicant__c applicant : Trigger.new) {
        if (applicant.Credit_Check_Performed__c) {
            // Fetch applicant's credit score from credit bureau integration
            Integer creditScore = CreditBureauIntegration.fetchCreditScore(applicant.SSN__c);
            
            // Calculate loan amount and interest rate range based on credit score and financial history
            Decimal loanAmount = LoanCalculator.calculateLoanAmount(creditScore, applicant.Income__c);
            Decimal interestRate = LoanCalculator.calculateInterestRate(creditScore, applicant.Income__c);
            
            // Update applicant's pre-qualification details
            applicant.Loan_Amount__c = loanAmount;
            applicant.Interest_Rate_Range__c = interestRate;
            applicantsToUpdate.add(applicant);
            
            // Save pre-qualification results for further processing
            PreQualificationResult__c preQualificationResult = new PreQualificationResult__c();
            preQualificationResult.Applicant__c = applicant.Id;
            preQualificationResult.Loan_Amount__c = loanAmount;
            preQualificationResult.Interest_Rate_Range__c = interestRate;
            insert preQualificationResult;
            
            // Send notification to the applicant
            NotificationService.sendNotification(applicant.Email__c, 'Pre-Qualification Status', 'Congratulations! You have been pre-qualified for a loan. Your loan amount is ' + loanAmount + ' and the interest rate range is ' + interestRate);
        }
    }
    
    // Update applicants with pre-qualification details
    update applicantsToUpdate;
}
