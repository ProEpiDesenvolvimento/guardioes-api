# Fix: Blank Screen When Accessing Quizzes After Deleting Versions

## Problem Description (in Portuguese)
"Após enviar três quizzes, dois sendo errados (duplicados), foi realizado via requisição "Delete" em "Flexible Forms Version" para remover os dois primeiros, deixando apenas o último. Entretanto, em seguida, ao entrar no APP - que utiliza requisição à API para obter os quizzes -, indo na aba dos quizzes, ele está com tela branca"

## Root Cause
When FlexibleFormVersion records were deleted via the DELETE endpoint, it was possible to delete all versions of a FlexibleForm, leaving the form without any versions. When the app subsequently called the quizzes endpoint (GET /flexible_forms/quizzes), the API would return FlexibleForm records that had no associated versions, causing serialization issues and resulting in a blank screen.

## Solution
The fix consists of two key changes:

### 1. Prevent Deletion of Last Version
Modified `FlexibleFormVersionsController#destroy` to prevent deletion of the last remaining version of a form:

```ruby
def destroy
  flexible_form = @flexible_form_version.flexible_form
  
  if flexible_form.flexible_form_versions.count <= 1
    render json: { error: 'Cannot delete the last version of a form' }, status: :unprocessable_entity
  else
    @flexible_form_version.destroy
  end
end
```

### 2. Filter Forms Without Versions
Modified the following endpoints to only return FlexibleForms that have at least one version:

- `GET /flexible_forms/quizzes` 
- `GET /flexible_forms/registration/:app_id`
- `GET /flexible_forms/signal`

This is achieved by adding `.joins(:flexible_form_versions).distinct` to the query:

```ruby
@flexible_forms = FlexibleForm.where(form_type: "quiz", group_manager_id: group_manager_id)
                               .joins(:flexible_form_versions)
                               .distinct
                               .order(created_at: :desc)
```

## Impact
- **Prevention**: Users can no longer delete the last version of a form, ensuring data integrity
- **Resilience**: Even if forms without versions exist in the database, they won't be returned by the API endpoints
- **User Experience**: The app no longer shows a blank screen when accessing quizzes

## Testing
Added comprehensive tests in:
- `spec/requests/flexible_form_versions_spec.rb` - Tests deletion prevention
- `spec/requests/flexible_forms_spec.rb` - Tests quizzes endpoint filtering

Created factories for:
- `FlexibleForm`
- `FlexibleFormVersion`

## Files Changed
- `app/controllers/flexible_form_versions_controller.rb`
- `app/controllers/flexible_forms_controller.rb`
- `spec/factories/flexible_form.rb` (new)
- `spec/factories/flexible_form_version.rb` (new)
- `spec/requests/flexible_form_versions_spec.rb`
- `spec/requests/flexible_forms_spec.rb`
