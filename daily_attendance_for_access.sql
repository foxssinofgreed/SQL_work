select l.row                                 as 'row',
       l.logID                               as 'logID',
       l.personID                            as 'personID',
       l.actionID                            as 'in',
       m.actionID                            as 'out',
       l.time                                as 'time_from',
       m.time                                as 'time_to',
       l.date                                as 'date',
       timestampdiff(minute, l.time, m.time) as 'minutes'
from (select row_number() over (order by l2.logID) as 'row', l2.logID, l2.personID, l2.actionID, l2.time, l2.date
      from access.logs l2
      where l2.personID = '50'
        and l2.date = '2021/01/13') l
         join (select row_number() over (order by l1.logID)     as 'row',
                      lead(l1.logID) over (order by l1.logID)    as 'logID',
                      lead(l1.personID) over (order by l1.logID) as 'personID',
                      lead(l1.actionID) over (order by l1.logID) as 'actionID',
                      lead(l1.time) over (order by l1.logID)     as 'time',
                      lead(l1.date) over (order by l1.logID)     as 'date'
               from access.logs l1
               where l1.personID = '50'
                 and l1.date = '2021/01/13') m on m.row = l.row
where l.actionID < m.actionID;