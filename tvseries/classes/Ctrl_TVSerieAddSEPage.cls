public class Ctrl_TVSerieAddSEPage {

	private final TV_Serie__c tv_series;
	public List<Season__c> seasons {get;set;}
	String seriesId {get; set;}
	String selectedSeriesId =ApexPages.currentPage().getParameters().get('id');
	public boolean addEpisode {get;set;}
	public boolean addSeason {get;set;}
	public Ctrl_TVSerieAddSEPage(ApexPages.StandardController stdController) {

		this.tv_series = (TV_Serie__c)stdController.getRecord();
		searchSeries();
	}

	public PageReference searchSeries(){

		seasons = [select id, Season_No__c from Season__c where TV_Serie__c =:selectedSeriesId
					ORDER BY Season_No__c ASC];

		return null;
	}

	public PageReference showEpisodes(){

		addEpisode = true;
		return null;
	}
	public PageReference showSeasons(){

		addSeason = true;
		return null;
	}

	public void saveSeason()
		{
			Season__c newSeason = new Season__c();
			newSeason.TV_Serie__c = selectedSeriesId;
			system.debug('Season: ' + newSeason);
		}
}