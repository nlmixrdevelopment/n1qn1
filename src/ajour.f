c Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
c Copyright (C) INRIA
c 
c Copyright (C) 2012 - 2016 - Scilab Enterprises
c
c This file is hereby licensed under the terms of the GNU GPL v2.0,
c pursuant to article 5.3.4 of the CeCILL v.2.1.
c This file was originally licensed under the terms of the CeCILL v2.1,
c and continues to be available under such terms.
c For more information, see the COPYING file which you should have received
c along with this program.
c
      subroutine ajour(mode,n,nc,nr,h,w,indi)
c
      implicit double precision (a-h,o-z)
      dimension h(*),w(n),indi(n)
c
c     mode = +1 factorise la ligne nc (indices de depart)
c          = -1 defactorise   '
c     nr nbre de lignes factorisees
c     h mat de dim n
c     w,d vect de travail
c     indi(i) ligne ou est stockee la ligne i de depart
c
      inc=indi(nc)
      nr1=nr+1
      nr2=nr-1
      nrr=n-nr
      nii=n-inc
      nkk=nr-inc
      if(mode.eq.-1)go to 240
c
c      addition d'une ligne a l
c
c          stockage des elements de la colonne inc dans w
      nsaut=nii+1
      nh=inc*(n+1)-inc*(inc+1)/2
      nw=n
      if(inc.eq.n) go to 20
      do i=1,nii
         w(nw)=h(nh)
         nw=nw-1
         nh=nh-1
      end do
   20 w(nr1)=h(nh)
      nh=nh-1
      if(inc.eq.nr1) go to 60
      do i=1,inc-nr1
         nl=nii+i-1
         if(nl.eq.0) go to 35
         do j=1,nl
            h(nh+nsaut)=h(nh)
            nh=nh-1
         end do 
 35      w(nw)=h(nh)
         nw=nw-1
         nh=nh-1
         nsaut=nsaut+1
      end do
      do j=1,inc-nr1
         h(nh+nsaut)=h(nh)
         nh=nh-1
      end do
c
   60 nw=nw-1
      nsaut=1
      if(nr.eq.0) go to 125
      if(inc.eq.n) go to 80
      do i=1,nii
         h(nh+nsaut)=h(nh)
         nh=nh-1
      end do
   80 if(nr.eq.1) go to 110
      do i=1,nr2
         w(nw)=h(nh)
         nw=nw-1
         nh=nh-1
         nsaut=nsaut+1
         if(n.eq.nr1) go to 100
         do  j=1,n-nr1
            h(nh+nsaut)=h(nh)
            nh=nh-1
         end do
      end do
  100 continue
  110 w(nw)=h(nh)
      nh=nh-1
      nsaut=nsaut+1
      if(inc.eq.nr1) go to 125
      do i=1,inc-nr1
         h(nh+nsaut)=h(nh)
         nh=nh-1
      end do
c         mise a jour de l
  125 if(nr.ne.0) go to 130
      if(w(1).gt.0.0d+0) go to 220
      mode=-1
      return
  130 if(nr.eq.1) go to 160
      do i=2,nr
         ij=i
         i1=i-1
         v=w(i)
         do j=1,i1
            v=v-h(ij)*w(j)
            ij=ij+nr-j
         end do
         w(i)=v
      end do
  160 ij=1
      v=w(nr1)
      do i=1,nr
         wi=w(i)
         hij=h(ij)
         v=v-(wi**2)/hij
         w(i)=wi/hij
         ij=ij+nr1-i
      end do
      if(v.gt.0.0d+0) go to 180
      mode=-1
      return
  180 w(nr1)=v
c          stockage de w dans h
      nh=nr*(nr+1)/2
      nw=nr1
      nsaut=nw
      h(nh+nsaut)=w(nw)
      nw=nw-1
      nsaut=nsaut-1
      if(nr.eq.1) go to 220
      do i=1,nr2
         h(nh+nsaut)=w(nw)
         nw=nw-1
         nsaut=nsaut-1
         do  j=1,i
            h(nh+nsaut)=h(nh)
            nh=nh-1
         end do
      end do
  220 h(nr1)=w(1)
      if(n.eq.nr1) go to 233
      nh1=nr*(n+1)-nr*(nr+1)/2+1
      nw=nr1
      do i=1,n-nr1
         h(nh1+i)=w(nw+i)
      end do
c          mise a jour de indi
 233  do i=1,n
         ii=indi(i)
         if(ii.le.nr.or.ii.ge.inc) go to 235
         indi(i)=ii+1
      end do
  235 continue
      nr=nr+1
      indi(nc)=nr
      mode=0
      return
c
c      soustraction d'une ligne a l
c
c          recherche des composantes de h
 240  do i=1,nr
         ik=i
         ij=inc
         ii=1
         ko=min(ik,inc)
         v=0.0d+0
         if(ko.eq.1) go to 252
         do k=1,ko-1
            nk=nr1-k
            v=v+h(ij)*h(ik)*h(ii)
            ij=ij+nk-1
            ii=ii+nk
            ik=ik+nk-1
         end do
 252     a=1.0d+0
         b=1.0d+0
         if(ko.eq.i) go to 253
         a=h(ik)
 253     if(ko.eq.inc) go to 260
         b=h(ij)
         w(i)=v+a*b*h(ii)
      end do
 260  continue
c          mise a jour de l
      if(inc.eq.nr) go to 315
      inc1=inc-1
      nh=inc1*nr1-inc1*inc/2+2
      nh1=nh+nkk
      di=h(nh-1)
      do j=1,nkk
         di1=h(nh1)
         nh1=nh1+1
         a=h(nh)
         ai=a*di
         c=(a**2)*di+di1
         h(nh)=c
         nh=nh+1
         if(j.eq.nkk) go to 315
         do i=1,nkk-j
            h1=h(nh)
            h2=h(nh1)
            u=ai*h1+h2*di1
            h(nh)=u/c
            h(nh1)=-h1+a*h2
            nh=nh+1
            nh1=nh1+1
         end do
         nh=nh+1
         di=di*di1/c
      end do
c          condensation de la matrice l
  315 nh=inc+1
      nsaut=1
      nj=nr-2
      if(inc.eq.1) nj=nj+1
      if(nr.eq.1) go to 440
      do i=1,nr2
         do j=1,nj
            h(nh-nsaut)=h(nh)
            nh=nh+1
         end do
         nsaut=nsaut+1
         nh=nh+1
         if(i.eq.inc-1) go to 430
         nj=nj-1
         if(nj.eq.0) go to 440
      end do
  430 continue
c          mise a jour de la matrice h
  440 nh=((nr*nr2)/2)+1
      nw=1
      nsaut=nr
      if(inc.eq.1) go to 470
      do i=1,inc-1
         h(nh)=w(nw)
         nw=nw+1
         nsaut=nsaut-1
         if(n.eq.nr) go to 455
         do j=1,nrr
            h(nh+j)=h(nh+nsaut+j)
         end do
 455     nh=nh+nrr+1
      end do
  470 nw=nw+1
      if(nr.eq.n) go to 485
      do i=1,nrr
         w(nr+i)=h(nh+nsaut+i-1)
      end do
      nsaut=nsaut+nrr
  485 if(inc.eq.nr) go to 510
      do i=1,nkk
         nsaut=nsaut-1
         h(nh)=w(nw)
         nw=nw+1
         if(nr.eq.n) go to 495
         do j=1,nrr
            h(nh+j)=h(nh+nsaut+j)
         end do
 495     nh=nh+nrr+1
      end do
  510 h(nh)=w(inc)
      if(nr.eq.n) go to 540
      do i=1,nrr
         h(nh+i)=w(nr+i)
      end do
c          mise a jour de indi
 540  do i=1,n
         ii=indi(i)
         if(ii.le.inc.or.ii.gt.nr) go to 550
         indi(i)=ii-1
      end do
  550 continue
      indi(nc)=nr
      nr=nr-1
      mode=0
      return
      end