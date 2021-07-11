describe('Todo Items Index', () => {
  it('shows item names', () => {
    cy.factorydb('todo_item', {}).then(({ body: item }) => {
      cy.visit('/todo-items');
      cy.get('p').contains(item.name).should('exist');
    });
  });
});
