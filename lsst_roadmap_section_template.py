import os

txt1 = """
%% LSST Extragalactic Roadmap
%% Chapter: %s 
%% First draft by 

\\chapter[%s]
\\label{ch:%s}

\input{%s/chapterintro.tex} 


"""

txt2 = """
%% LSST Extragalactic Roadmap
%% Chapter: %s 
%% Section: %s
%% First draft by 

\\section{XXX}\\label{sec:%s:XXX}  

"""

files = {"science_background":['bkg', 
    ['black_holes','galaxies','informatics','lss','strong_lensing','weak_lensing'],
    ['agn','gal','ai','lss','sl','wl'],"Science Background"],
    "task_lists":['tasks', 
    ['black_holes','galaxies','informatics','lss','strong_lensing','weak_lensing'],
    ['agn','gal','ai','lss','sl','wl'],"Task Lists by Science Area"]
}

for chap in files.keys():
    print "------ %s -----" % (chap)
    chapterfp = open("%s/%s.tex" % (chap,chap),"w")
    chaptertitle = files[chap][3]
    header = txt1 % (chap,chaptertitle,chap,chap)
    chapterfp.write(header)
    for i,subdir in enumerate(files[chap][1]):
        nickname = files[chap][2][i]
        path = "%s/%s/%s.tex" % (chap,subdir,subdir)
        fp = open(path,'w')
        header = txt2 % (chap,subdir,nickname)
        fp.write(header)
        fp.close()
        chapterfp.write("\input{%s/%s/%s.tex}\n\n" %  (chap,subdir,subdir))
    chapterfp.close()
