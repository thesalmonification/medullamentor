import cv2
import numpy as np
import pandas as pd
import glob


broken_structures = ['optic chiasm',
'motor trigeminal nucleus right',
'inferior colliculus right',
'principal sensory trigeminal nucleus right',
'cuneate nucleus right',
'corticospinal tract right',
'pulvinar nuclei left',
'hypoglossal nucleus right',
'abducens nucleus left',
'obex',
'mesencephalic trigeminal tract left',
'cerebral aqueduct',
'motor trigeminal nucleus left',
'principal sensory trigeminal nucleus left',
'spinal trigeminal nucleus interpolaris left',
'middle cerebellar peduncle left',
'pulvinar nuclei right',
'hypoglossal nucleus left',
'abducens nucleus right',
'abducens nerve left',
'superior colliculus right',
'trigeminal nerve left',
'trigeminal nerve right',
'anterior commissure',
'inferior colliculus left',
'decussation superior cerebellar peduncles',
'inferior cerebellar peduncle left',
'inferior cerebellar peduncle right',
'red nucleus right',
'red nucleus left',
'facial nerve left',
'pyramidal decussation',
'thalamus excluding pulvinar left',
'cuneate fasciculus right',
'cuneate fasciculus left']

color = 'yellow'

#Read all images in the directory
images = glob.glob(color+'/*.png')
images.sort()



for image in [images[0]]: #I add list around this loop if I'm trying to correct a single file...
    image_name = image[-15:-4]
    print('\nWE ARE NOW WORKING ON IMAGE: ' + image_name)


    #Reading the json files...
    df = pd.read_json(color+'labelsplitjson/'+image_name+'_splits.json',orient='index')
    #print(df)

    
    #image + full superimposed labels...
    mri = cv2.imread(color+'/'+image_name+'.png')
    labels = cv2.imread(color+'labels/'+image_name+'.png')
    added_image = cv2.addWeighted(mri,0.4,labels,1,0)

    #Now I need to do an inner loop for all split label images...
    split_label_images = glob.glob(color+'labelsplit/'+image_name+'*.png')
    split_label_images.sort()
    #print(split_label_images)

    changed_structures = []
    for split_label_image in split_label_images:
        #print(split_label_image)
        #Grab the single split label image...
        image2 = cv2.imread(split_label_image)
        split_label = cv2.addWeighted(mri,0.4,image2,1,0)

        current_label = str(df[df[0] == split_label_image[17:]].index[0])

        if current_label not in broken_structures: #I'm doing this to reduce the number of split images I see. Hopefully speeds up to only incorrectly labeled structures. 
            continue
        
        #Concatentate and display images...
        numpy_horizontal_concat = np.concatenate((added_image, split_label), axis=1)
        cv2.imshow(split_label_image+'- CURRENT LABEL is: '+current_label, numpy_horizontal_concat)
        cv2.waitKey(0)
        print('\nFor Image ' + split_label_image + ' the current label is: ' + current_label)
        print('Is this correct (Y/n)')
        x = input()

        if x == 'Y' or x == 'y':
            cv2.destroyAllWindows()
        else:
            print('Okay. Please enter the correct name structure:')
            x = input()
            df.rename(index={current_label:x},inplace=True)
            print("I've renamed " + current_label + " to " + x)
            changed_structures.append({current_label:x})
            cv2.destroyAllWindows()
        
    print('\nYour Final DataFrame looks as follows:')
    print(df)
    print('Do you want to save? (Y/n)')
    x=input()
    if x == 'Y' or x == 'y':
        df_image = pd.read_json(color+'json/'+image_name+'.json')
        
        for structure_pair in changed_structures:
            df_image.replace(structure_pair,inplace=True)

        df_image.to_json(color+'jsonCORRECTED/'+image_name+'.json')
        df[0].to_json(color+'labelsplitjsonCORRECTED/'+image_name+'_splits.json')
        print('Okay. The DataFrame has been saved.')
        pass
    else:
        print('DID NOT SAVE')
        pass

