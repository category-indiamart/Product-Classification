# Product-Classification

#### Framing the Business Problem :

One of the important steps in Machine Learning is getting your problem statement correct.  This will help you get the right algorithm to solve your problem or even build a new one. 

#### My Problem Statement 

We had to map various products to their most appropriate available category . eg long grain 2 year aged rice should be mapped to "basmati rice" while long grain ,aged india gate rice should be claasified as "India Gate Basmati rice". 
To map products in most relevant category, we considered the following parameters(textual inputs):
> Product Name(PC_ITEM_NAME),
> It's Specification like long grain , aged for 2 years , brand etc
> Product description(only relevant information).

#### Choice of Tools 

We narrowed on [fasttext](https://fasttext.cc/docs/en/supervised-tutorial.html) based classifier and used R for processing our data. Our CLI here was cygwin but this is a personal choice, you just need to know some basic shell commands.

#### Links to download required tools

[Install R](https://cran.r-project.org/bin/windows/base/)

[Install R Studio](https://www.rstudio.com/products/rstudio/download/)

[Install Cygwin](http://www.cygwin.com/install.html)

#### Defining the SubCAT at 3 levels of taxonomy. 
```
PMCAT(except Super PMCAT).
Brand MCAT.
Non Brand MCAT.
```

### Steps:-

##### 1. Extracting products data using SQL query. 

The extracted data contains the fields like:
```
PRIME_MCAT_ID,PRIME_MCAT_NAME	PRIME_MCAT_IS_GENERIC,FK_MCAT_TYPE_ID,GOOD PMCAT,OTHER_MCATS,	FK_GLCAT_MCAT_ID, PC_ITEM_ID, 
PC_ITEM_NAME,PC_ITEM_IMG_ORIGINAL	PC_ITEM_GLUSR_USR_ID, PC_ITEM_GLCAT_MCAT_ID_LIST, 	PC_ITEM_GLCAT_MCAT_NAME_LIST	,
PC_ITEM_STATUS_APPROVAL	PC_ITEM_DESC_SMALL,FK_IM_SPEC_MASTER_ID, FK_IM_SPEC_MASTER_DESC	FK_IM_SPEC_OPTIONS_ID, 
FK_IM_SPEC_OPTIONS_DESC,Response MCAT	PC_ITEM_ATTRIBUTE_MOD_DATE,Current MCAT.
```
Pls use the following [SQL query](https://docs.google.com/document/d/1HRJ7gVkiH1n5XFMAnLUbnYqmAFCD3Kt3zS4eS-d-dSU/edit?usp=sharing) to get the above data.

##### 2.Data processing in Excel. 
Since data extracted from query contains to many fields for our analysis, we proceed with required fields like:

> PRIME_MCAT_ID,PRIME_MCAT_NAME	PRIME_MCAT_IS_GENERIC,FK_MCAT_TYPE_ID,GOOD 
> PMCAT,PC_ITEM_ID,PC_ITEM_NAME,PC_ITEM_DESC_SMALL,FK_IM_SPEC_OPTIONS_DESC.

Also our data contained multiple rows for same product having different specification options. So we constructed a single row per product thus combining all specification options to get combined data against unique PC_ITEM_ID.
> Concat all Options_Desc to get filled responses against unique Item_Id.

> For PMCAT training data- Take PMCAT and PMCAT flag against each MCAT_ID. Consider MCAT having flag 2 as good pmcat, and if its child 
> we consider its parent with flag ‘2’ as good PMCAT.
> Consider only filtered good PMCAT data for training.

> To get training data for child_mcats just untick MCAT_FLAG ‘2’ from Good_PMCAT_data for training the model on child mcats(2nd level).

##### 3. Data Cleaning and processing in R.
After getting excel file with unique PC_ITEM_IDs we need to process the file in an R-script to clean the data and create the corpus for training and testing files. Here we have divided training and testing dataset into 10 folds to reduce bias in the model. 
```
*PC_ITEM_NAME - Only change to lower case and remove the special character.
*PRODUCT_DESCRIPTION- Keep only bulleted data from the description and ignore flowery contents.
*IM_SPEC_OPTION_DESCRIPTION- After concatenating entire options, remove options like: 50Kg, 50 Kilogram etc.
*Then contact all three column to separate training and testing files.
```

Use this  [R-Script](https://docs.google.com/document/d/1xIrCenWrLn1MFzNp6IUB1Z81mgpgfbZTJIIv_XIGFUQ/edit?usp=sharing) to perform the above steps.

#### K-Fold validation:- 
It provides a robust estimate of the performance of a model on unseen data. It does this by splitting the training dataset into k subsets and takes turns training models on all subsets except one which is held out, and evaluating model performance on the held out validation dataset. The process is repeated until all subsets are given an opportunity to be the held out validation set. The performance measure is then averaged across all models that are created.

##### Developing model in Cygwin with k-fold:-
Create a list in vi editors with contains numeric values from 1 to 10. 
Use command: ```vi file and insert values.```
We can also create a file list containing different file names so that we can train the entire set of data in one go.
###### To create a list as per our choice use below command:

```           find /cygdrive/c/Users/Ashutosh/Desktop/corpusrar/ -name \*.txt -printf "%f\n" > list ```


##### Train the model using following command: 
```
while read p; do fasttext/fasttext.exe supervised -input /cygdrive/e/KFold/Wheel\ Loader/Training\ Files_brand/$p.txt -output /cygdrive/e/KFold/Wheel\ Loader/Training\ Files_brand/bin/$p -lr 0.8 -minn 4 -epoch 25 -wordNgrams 1 -lrUpdateRate 100 -thread 4 -loss hs; done < file
```
##### Testing command to get output data:
```
while read p ; do fastText/fasttext.exe predict-prob /cygdrive/e/KFold/Wheel\ Loader/Training\ Files_brand/bin/$p.bin /cygdrive/e/KFold/Wheel\ Loader/Testing_pmcat/$p.txt 2 > /cygdrive/e/KFold/Wheel\ Loader/out_brand/$p.out ;done < file 
```
##### After getting output data, we combine the output result(.out) file and testing data-set to get final output. Use following commands to get final output(combined data).
```
while read p ; do paste /cygdrive/e/KFold/Wheel\ Loader/Testing_pmcat/$p.txt /cygdrive/e/KFold/Wheel\ Loader/out_brand/$p.out |column -s $'\t' -t > /cygdrive/e/KFold/Wheel\ Loader/out_brand/$p.final ; done < file
```

The combined data is a (.final) file. To convert (.final) files to (.csv)--> Open command prompt and run ``` “ren *.final *.csv” ``` in the final files directory.

##### Processing combined output file in R to get output in readable format.
We have created another r-script which will convert all the output files into readable format in one go.  
Use following [R-script](https://docs.google.com/document/d/1qNoWZFzQIGHnFQ4voRTvRODQR8ELbA0mp5SjzLcZKFA/edit?usp=sharing) to get output data in readable format.
This script will create K output files(.csv) or (.xlsx) for K different folds , which can be directly used for further analysis.

Processing output files at [child level](https://docs.google.com/document/d/1vKZK1ZYMZOaLKOysxo5Y_hv8EMujW1n36Lf68faS2ZU/edit?usp=sharing).


## Same Procedure to be followed for BL classification without using K-fold cross validation:

#### We will train the model on :
> Entire PMCAT products data
> Entire Brand products data
> Entire Child Products data

#### Testing to be done on BL data of same MCAT/PMCAT. 
#### Same command to be used w/o kfold.


##### Making the model better -hyper-parameter tuning:

Getting to the right mix for your trainig parameters requires a lot of experimentation but fruits of labour will be sweet. The code below is one which will automatically train and test your model on a given set of paramters , will comapre the results with the supposed output and help to choose the most suited one . Please note choice and variation of parameters is a personal choice and depends much upon your problem statement .
```
$ while read p; do while read q; do fastText/fasttext.exe supervised -input /cygdrive/e/Yarn_new/Yarn_NPS/Child/Training\ Files/$q.txt -output /cygdrive/e/Yarn_new/Yarn_NPS/Child/bin/$p.$q -lr 0.8 -minn 4 -epoch 25 -wordNgrams 1 -lrUpdateRate 100 -thread 4 -loss hs; done < /cygdrive/e/Yarn_new/Yarn_NPS/nps_yarn_list ; done < lr_range ;
```
