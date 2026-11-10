-- بيتوت: صلاحيات قسم "الخطة الإنتاجية"
-- بيضيف صلاحيات جديدة بس، ومش بيغيّر أي صلاحية قديمة أو أي بيانات

-- 1) الكل يشوف الخطة (المدير، الحسابات، الإنتاج، المخزن)
drop policy if exists plans_select on public.docs;
create policy plans_select on public.docs for select to authenticated
  using (collection = 'plans' and public.my_role() in ('admin','accounts','production','warehouse'));

-- 2) المدير والإنتاج يضيفوا ويعدّلوا ويمسحوا بنود الخطة
drop policy if exists plans_insert on public.docs;
create policy plans_insert on public.docs for insert to authenticated
  with check (collection = 'plans' and public.my_role() in ('admin','production'));

drop policy if exists plans_update on public.docs;
create policy plans_update on public.docs for update to authenticated
  using (collection = 'plans' and public.my_role() in ('admin','production'))
  with check (collection = 'plans' and public.my_role() in ('admin','production'));

drop policy if exists plans_delete on public.docs;
create policy plans_delete on public.docs for delete to authenticated
  using (collection = 'plans' and public.my_role() in ('admin','production'));

-- 3) الإنتاج والمخزن يشوفوا سجل التعديلات بتاع القسم ده
drop policy if exists plans_history_select on public.docs;
create policy plans_history_select on public.docs for select to authenticated
  using (collection = 'history' and data->>'area' = 'plan' and public.my_role() in ('production','warehouse'));
