/*
 * Unit tests for DolphinViewOpacity configuration
 *
 * Tests the new DolphinViewOpacity setting that controls
 * transparency of Dolphin's main file view area.
 */

#include <QTest>
#include <QTemporaryDir>
#include <QStandardPaths>

#include "darkystyleconfigdata.h"

class DolphinViewOpacityTest : public QObject
{
    Q_OBJECT

private:
    QTemporaryDir m_tempDir;

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

    // Configuration tests
    void testDefaultValue();
    void testSetAndGetValue();
    void testBoundaryValues();
    void testPersistence();
    void testIndependentFromSidebarOpacity();
};

void DolphinViewOpacityTest::initTestCase()
{
    // Use temporary directory for config files
    QVERIFY(m_tempDir.isValid());
    QStandardPaths::setTestModeEnabled(true);
}

void DolphinViewOpacityTest::cleanupTestCase()
{
    QStandardPaths::setTestModeEnabled(false);
}

void DolphinViewOpacityTest::init()
{
    // Reset to defaults before each test
    Darky::StyleConfigData::self()->setDefaults();
}

void DolphinViewOpacityTest::cleanup()
{
    // Nothing to clean up
}

void DolphinViewOpacityTest::testDefaultValue()
{
    // The default value should be 100 (fully opaque)
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 100);
}

void DolphinViewOpacityTest::testSetAndGetValue()
{
    // Test setting various valid values
    Darky::StyleConfigData::setDolphinViewOpacity(50);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 50);

    Darky::StyleConfigData::setDolphinViewOpacity(0);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 0);

    Darky::StyleConfigData::setDolphinViewOpacity(75);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 75);

    Darky::StyleConfigData::setDolphinViewOpacity(100);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 100);
}

void DolphinViewOpacityTest::testBoundaryValues()
{
    // Test minimum value (0 = fully transparent)
    Darky::StyleConfigData::setDolphinViewOpacity(0);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 0);

    // Test maximum value (100 = fully opaque)
    Darky::StyleConfigData::setDolphinViewOpacity(100);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 100);

    // Test value at 1 (near minimum)
    Darky::StyleConfigData::setDolphinViewOpacity(1);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 1);

    // Test value at 99 (near maximum)
    Darky::StyleConfigData::setDolphinViewOpacity(99);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 99);
}

void DolphinViewOpacityTest::testPersistence()
{
    // Set a non-default value
    Darky::StyleConfigData::setDolphinViewOpacity(42);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 42);

    // Save configuration
    Darky::StyleConfigData::self()->save();

    // Reset to defaults
    Darky::StyleConfigData::self()->setDefaults();
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 100);

    // Reload configuration
    Darky::StyleConfigData::self()->load();
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 42);
}

void DolphinViewOpacityTest::testIndependentFromSidebarOpacity()
{
    // Set different values for view and sidebar opacity
    Darky::StyleConfigData::setDolphinViewOpacity(30);
    Darky::StyleConfigData::setDolphinSidebarOpacity(70);

    // Verify they are independent
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 30);
    QCOMPARE(Darky::StyleConfigData::dolphinSidebarOpacity(), 70);

    // Change one, verify the other is unaffected
    Darky::StyleConfigData::setDolphinViewOpacity(50);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 50);
    QCOMPARE(Darky::StyleConfigData::dolphinSidebarOpacity(), 70);

    Darky::StyleConfigData::setDolphinSidebarOpacity(25);
    QCOMPARE(Darky::StyleConfigData::dolphinViewOpacity(), 50);
    QCOMPARE(Darky::StyleConfigData::dolphinSidebarOpacity(), 25);
}

QTEST_MAIN(DolphinViewOpacityTest)
#include "dolphinviewopacity_test.moc"
