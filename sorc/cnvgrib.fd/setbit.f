C> @file
C>
C> @author IREDELL @date 92-10-31
C
C>  THE NUMBER OF BITS REQUIRED TO PACK A GIVEN FIELD
C>  FOR PARTICULAR BINARY AND DECIMAL SCALINGS IS COMPUTED.
C>   THE MINIMUM AND MAXIMUM ROUNDED FIELD VALUES ARE ALSO RETURNED.
C>   GRIB BITMAP MASKING FOR VALID DATA IS OPTIONALLY USED.
C>
C> PROGRAM HISTORY LOG:
C>   96-09-16  IREDELL
C>
C> USAGE:    CALL SETBIT(IBM,IBS,IDS,LEN,MG,G,GMIN,GMAX,NBIT)
C>   INPUT ARGUMENT LIST:
C>     IBM      - INTEGER BITMAP FLAG (=0 FOR NO BITMAP)
C>     IBS      - INTEGER BINARY SCALING
C>                (E.G. IBS=3 TO ROUND FIELD TO NEAREST EIGHTH VALUE)
C>     IDS      - INTEGER DECIMAL SCALING
C>                (E.G. IDS=3 TO ROUND FIELD TO NEAREST MILLI-VALUE)
C>                (NOTE THAT IDS AND IBS CAN BOTH BE NONZERO,
C>                 E.G. IDS=1 AND IBS=1 ROUNDS TO THE NEAREST TWENTIETH)
C>     LEN      - INTEGER LENGTH OF THE FIELD AND BITMAP
C>     MG       - INTEGER (LEN) BITMAP IF IBM=1 (0 TO SKIP, 1 TO KEEP)
C>     G        - REAL (LEN) FIELD
C>
C>   OUTPUT ARGUMENT LIST:
C>     GMIN     - REAL MINIMUM VALID ROUNDED FIELD VALUE
C>     GMAX     - REAL MAXIMUM VALID ROUNDED FIELD VALUE
C>     NBIT     - INTEGER NUMBER OF BITS TO PACK
C>
C> ATTRIBUTES:
C>   LANGUAGE: FORTRAN 90
C>
C>
      SUBROUTINE SETBIT(IBM,IBS,IDS,LEN,MG,G,GMIN,GMAX,NBIT)

      DIMENSION MG(LEN),G(LEN)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  ROUND FIELD AND DETERMINE EXTREMES WHERE BITMAP IS ON
      S=2.**IBS*10.**IDS
      IF(IBM.EQ.0) THEN
        GMAX=G(1)
        GMIN=G(1)
        DO I=2,LEN
          GMAX=MAX(GMAX,G(I))
          GMIN=MIN(GMIN,G(I))
        ENDDO
      ELSE
        I1=1
        DOWHILE(I1.LE.LEN.AND.MG(I1).EQ.0)
          I1=I1+1
        ENDDO
        IF(I1.LE.LEN) THEN
          DO I=1,I1-1
            G(I)=0.
          ENDDO
          GMAX=G(I1)
          GMIN=G(I1)
          DO I=I1+1,LEN
            IF(MG(I).NE.0) THEN
              GMAX=MAX(GMAX,G(I))
              GMIN=MIN(GMIN,G(I))
            ELSE
              G(I)=0.
            ENDIF
          ENDDO
        ELSE
          DO I=1,LEN
            G(I)=0.
          ENDDO
          GMAX=0.
          GMIN=0.
        ENDIF
      ENDIF
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  COMPUTE NUMBER OF BITS
      NBIT=LOG((GMAX-GMIN)*S+0.9)/LOG(2.)+1.
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      RETURN
      END
