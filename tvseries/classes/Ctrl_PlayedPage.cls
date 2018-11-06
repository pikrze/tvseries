/*
 * Created by piotr.krzeminski on 31.10.2018.
 */
public class Ctrl_PlayedPage {
	public Played__c play{get;set;}
	public list<Played__c> pl {get;set;}
	public String characterName{get;set;}
	public String selectedPlayId = ApexPages.currentPage().getParameters().get('id');
	public Ctrl_PlayedPage(ApexPages.StandardController stdController) {

		this.play = (Played__c)stdController.getRecord();
		pl = [select id, Cast__r.id from Played__c where id=:selectedPlayId];


	}

	public PageReference deleteAssignedSerie(){

		List<Played__c> destroyedAssigned = [select id, Cast__c from Played__c where id=:selectedPlayId];
		delete destroyedAssigned;
		PageReference page = new PageReference('/apex/CastPage?id='+destroyedAssigned[0].Cast__c);
		return page;
	}

	public void updateCharacter(){

		try {

			Played__c p2 = [select id, name, character__c from Played__c where id=:selectedPlayId];

			if(characterName != null) {

				p2.Character__c = characterName;


				Database.SaveResult saveResult = Database.update(p2, false);
				if (saveResult.isSuccess() == true)
				{

					ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info, 'Update successfukl!'));
					system.debug('Update sucessful');

				} else
				{
					system.debug(logginglevel.ERROR, 'Update fail!');
					ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Update Fail!'));

				}
			}
		} catch (exception ex)
		{
			system.debug(logginglevel.ERROR, 'cannot save update' + ex);


		}

	}



}