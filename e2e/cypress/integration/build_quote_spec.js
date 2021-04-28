
describe('Quotes', function () {
    it('Can build and email a quote', function () {
        cy.visit("/")
        // create case file
        cy.contains('New Quote').click();
        cy.get('#quote_title').type("New Office Supplies");
        cy.get('#quote_email').type("office@supplies.com");
        cy.contains('Create').click();
        cy.contains('Quote was successfully created.')

        cy.contains('Add Product').click();
        cy.get('#quote_product_product').select("Book");
        cy.get('#quote_product_amount').type("100");
        cy.contains('Add').click();
        cy.contains('product was successfully added.')

        cy.contains('100 Books for $57.5');
        cy.contains('For a Total of $57.5');

        cy.contains('Add Product').click();
        cy.get('#quote_product_product').select("Face mask");
        cy.get('#quote_product_amount').type("200");
        cy.contains('Add').click();
        cy.contains('product was successfully added.')

        cy.contains('100 Books for $57.5');
        cy.contains('200 Face masks for $210.0');
        cy.contains('For a Total of $267.5');

        cy.contains('Add Product').click();
        cy.get('#quote_product_product').select("First aid kit");
        cy.get('#quote_product_amount').type("10");
        cy.contains('Add').click();
        cy.contains('product was successfully added.')

        cy.contains('100 Books for $57.5');
        cy.contains('200 Face masks for $210.0');
        cy.contains('10 First aid kits for $100');
        cy.contains('For a Total of $367.5');
    })
});
