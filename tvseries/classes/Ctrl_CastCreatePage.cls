/*
 * Created by piotr.krzeminski on 22.10.2018.
 */
public class Ctrl_CastCreatePage {

	public Cast__c tv_cast{
		get;set;
	}
    public List<String> roles{
        get; set;
    }
	public String title {
		get; set;
	}
	public String testValue{
		get;set;
	}
	public String description{
		get; set;
	}
	public String selectedCategory {
		get; set;
	}
	public String selectedCountry {
		get; set;
	}
	public boolean validation{
		get; set;
	}

	public Ctrl_CastCreatePage(ApexPages.StandardController stdController) {

		this.tv_cast = new Cast__c();


	}

	public List<SelectOption> getCategory() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Cast__c.Role__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('-', '-'));

		for (Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}


		System.debug(options);
		return options;
	}

	public List<SelectOption> getCountry() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = Cast__c.Nationality__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();


		options.add(new SelectOption('-', '-'));

		for (Schema.PicklistEntry f : ple)
			{
				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}


		System.debug(options);
		return options;
	}

	public PageReference addSeries() {

		Cast__c tv_cast2 = new Cast__c();
		String newUrl;
		//System.debug(logginglevel.INFO,'Enter the addSeries Method');
		try
		{
			System.debug('wchodzimy w try');
			 System.debug('role:'+roles[0]+' '+roles[1]);
			//system.debug(title);
			if (tv_cast.Name__c != null && tv_cast.Surname__c != null && tv_cast.Birth_Date__c != null &&
							roles != null) {
				System.debug('weszlismy w IFA');
				tv_cast2.Name__c = tv_cast.Name__c;
				tv_cast2.Surname__c = tv_cast.Surname__c;
				tv_cast2.Birth_Date__c = tv_cast.Birth_Date__c;
				tv_cast2.Biography__c = tv_cast.Biography__c;
				tv_cast2.Nationality__c = tv_cast.Nationality__c;
                 String roleList ='';
                               
                for(Integer i = 0; i<roles.size(); i++ )
                {
                    if(i == roles.size()-1){
                        roleList += roles[i];
                    }else{
                    roleList += roles[i] +';';
                    }
                    
                }
                tv_cast2.Role__c = roleList;
				
				System.debug('lista: '+roleList);

				system.debug('co tu sie dzieje? ' + tv_cast2.Name__c);

				Database.SaveResult saveResult = Database.insert(tv_cast2, false);
				if (saveResult.isSuccess())
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Insert Successful'));
					newUrl = '/apex/CastPage?id=' + tv_cast2.id + '&sfdc.override=1';
					PageReference pageRef = new PageReference(newUrl);
					return pageRef;
				}
			} else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
						'Please be kind to fill in all of the required fields'));
				return null;
			}

		} catch (exception ex)
		{
			system.debug(logginglevel.ERROR, 'Error');
			return null;
		}
		return null;

	}

	public void sprawdzamCzyDziala() {

		System.debug('WARTOSC: ' + tv_cast.Name__c);
	}

}